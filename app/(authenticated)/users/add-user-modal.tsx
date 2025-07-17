"use client";

import { useState, useEffect, FormEvent } from "react";
import ky from "ky";
import { createBrowserClient } from "@supabase/ssr";
import { UnassignedEmployee } from "./page";

type Props = {
  unassignedEmployees: UnassignedEmployee[];
};

export default function AddUserModal({ unassignedEmployees }: Props) {
  const [alert, setAlert] = useState<string>("");
  const [isOpen, setIsOpen] = useState(false);
  const [profile, setProfile] = useState<"admin" | "manager">("admin");
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());
  const [taskId, setTaskId] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

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

  const resetModal = () => {
    setAlert("");
    setProfile("admin");
    setSelectedIds(new Set());
    setTaskId(null);
    setIsSubmitting(false);
  };

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    setAlert("");

    const payload = { user_ids: Array.from(selectedIds), profile };

    try {
      const { data: task, error: insertError } = await supabase
        .from("async_tasks")
        .insert({
          endpoint: "/users/signup_all",
          status: "in_progress",
          payload: {
            user_ids: payload.user_ids,
            profile: payload.profile,
          },
        })
        .select()
        .single();

      if (insertError || !task) {
        console.error("Failed to create task:", insertError);
        setAlert("Failed to create task. Please try again.");
        setIsSubmitting(false);
        return;
      }

      setTaskId(task.id);

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
      setAlert("Error creating users. Please try again.");
      setIsSubmitting(false);
    }
  };

useEffect(() => {
  if (!taskId) return;

  let channel: any = null;

  const getTaskStatus = async () => {
    try {
      const res = await ky.get(`/api/async_tasks/${taskId}`);
      const data = await res.json<{
        id: string;
        status: string;
      }>();

      console.log(data);
      // if the status is already done or error, mutate the call that fetches user_api data (race condition). The get call above should fetch the status of the task.
      if (data.status === "done" || data.status === "error") {
        console.log("Task already completed with status:", data.status);
        setIsOpen(false);
        resetModal();
        window.location.reload();
      }

      // Only set up the listener if the task is still in progress
      channel = supabase
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
            console.log("Task status update:", payload.new.status);
            if (
              payload.new &&
              payload.new.id === taskId &&
              (payload.new.status === "done" ||
                payload.new.status === "error")
            ) {
              setIsOpen(false);
              resetModal();
              window.location.reload();
            }
          }
        )
        .subscribe();
    } catch (error) {
      console.error("Error fetching task status:", error);
    }
  };

  getTaskStatus();

  // Cleanup function
  return () => {
    if (channel) {
      channel.unsubscribe();
    }
  };
}, [taskId]);

  const handleClose = () => {
    if (!isSubmitting) {
      setIsOpen(false);
      resetModal();
    }
  };

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
            onClick={handleClose}
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
                disabled={isSubmitting}
              >
                <option value="admin">Admin</option>
                <option value="manager">Manager</option>
              </select>
            </label>

            <fieldset className="space-y-1">
              <legend>Employees without a user account and profile</legend>
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
                      disabled={isSubmitting}
                    />
                    {e.first_name} {e.last_name}
                  </label>
                ))
              )}
            </fieldset>

            <div className="flex items-center justify-between mt-4">
              <button
                type="submit"
                disabled={selectedIds.size === 0 || isSubmitting}
                className="bg-green-600 hover:bg-green-700 text-white py-2 px-4 rounded disabled:opacity-50"
              >
                {isSubmitting ? "Submitting..." : "Submit"}
              </button>
              <button
                type="button"
                onClick={handleClose}
                className="text-gray-500 hover:underline"
                disabled={isSubmitting}
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
