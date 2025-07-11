"use client";

import { useState, useEffect, FormEvent } from "react";
import { useRouter } from "next/navigation";
import ky from "ky";
import { createBrowserClient } from "@supabase/ssr";
import { UnassignedEmployee } from "./page";

type Props = {
  unassignedEmployees: UnassignedEmployee[];
};

export default function AddUserModal({ unassignedEmployees }: Props) {
  const router = useRouter();
  const [alert, setAlert] = useState<string>("");
  const [isOpen, setIsOpen] = useState(false);
  const [profile, setProfile] = useState<"admin" | "manager">("admin");
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());
  const [taskId, setTaskId] = useState<string | null>(null);

  const supabase = createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );

  const toggleSelect = (id: string) => {
    setSelectedIds((prev) => {
      const next = new Set(prev);
      next.has(id) ? next.delete(id) : next.add(id);
      return next;
    });
  };

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    const payload = { user_ids: Array.from(selectedIds), profile };

    try {
      const { data: task, error: insertError } = await supabase
        .from("async_tasks")
        .insert({
          endpoint: "/users/signup_all",
          status: "in_progress",
          payload: {
            user_ids: payload.user_ids,
            profile: payload.profile, // TODO: Can make this an enum type
          },
        })
        .select()
        .single();

      if (insertError || !task) {
        console.error("Failed to create task:", insertError);
        return;
      }

      // Monitor the task id
      setTaskId(task.id);

      // Call /tasks/trigger to start processing
      const response = await ky.post("/api/tasks", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ id: task.id }),
      });

      if (!response.ok) {
        throw new Error("Failed to trigger task");
      }
    } catch (error) {
      console.error("Error creating users:", error);
    }
  };

  useEffect(() => {
    if (!taskId) return;

    const channel = supabase
      .channel(`async_tasks_listener_${taskId}`)
      .on(
        "postgres_changes",
        {
          schema: "public",
          table: "async_tasks",
          event: "UPDATE",
          filter: `id=eq.${taskId}`,
        },
        (payload) => {
          if (payload.new.status === "done" || payload.new.status === "error") {
            window.location.reload();
          }
        }
      )
      .subscribe();

    return () => {
      channel.unsubscribe();
    };
  }, [taskId, router]);

  return (
    <>
      <button
        onClick={() => setIsOpen(true)}
        className="mb-4 bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-4 rounded"
        style={{ marginLeft: "2.5rem" }}
      >
        Add User
      </button>

      {isOpen && (
        <div className="fixed inset-0 flex items-center justify-center z-50">
          <div
            className="absolute inset-0 bg-black opacity-50"
            onClick={() => setIsOpen(false)}
          />
          <form
            onSubmit={handleSubmit}
            className="bg-white p-6 rounded-lg shadow-lg z-10 w-full max-w-lg space-y-4"
          >
            {alert && <p className="text-red-500">{alert}</p>}

            <h2 className="text-xl font-bold">Create New Users</h2>

            <label className="block">
              Profile
              <select
                value={profile}
                onChange={(e) =>
                  setProfile(e.target.value as "admin" | "manager")
                }
                className="mt-1 block w-full border rounded px-2 py-1"
              >
                <option value="admin">Admin</option>
                <option value="manager">Manager</option>
              </select>
            </label>

            <fieldset className="space-y-1">
              <legend>Employees without a user_api record</legend>
              {unassignedEmployees.length === 0 ? (
                <p className="text-gray-500">All employees already users.</p>
              ) : (
                unassignedEmployees.map((e) => (
                  <label key={e.id} className="flex items-center gap-2">
                    <input
                      type="checkbox"
                      checked={selectedIds.has(e.id)}
                      onChange={() => toggleSelect(e.id)}
                      className="form-checkbox"
                    />
                    {e.first_name} {e.last_name}
                  </label>
                ))
              )}
            </fieldset>

            <div className="flex items-center justify-between mt-4">
              <button
                type="submit"
                disabled={selectedIds.size === 0}
                className="bg-green-600 hover:bg-green-700 text-white py-2 px-4 rounded disabled:opacity-50"
              >
                Submit
              </button>
              {taskId && (
                <span className="text-sm text-gray-600">
                  Task ID: <code>{taskId}</code>
                </span>
              )}
              <button
                type="button"
                onClick={() => setIsOpen(false)}
                className="text-gray-500 hover:underline"
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}
    </>
  );
}
