"use client";

import { createBrowserClient, createServerClient } from "@supabase/ssr";
import ky from "ky";
import { cookies } from "next/headers";
import { useState, useEffect, FormEvent } from "react";
import { UnassignedEmployee } from "./page";

type EmployeeOption = {
  id: string;
  first_name: string;
  last_name: string;
};

export default function AddUserModal({
  unassignedEmployees,
}: {
  unassignedEmployees: UnassignedEmployee[];
}) {
  const [isOpen, setIsOpen] = useState(false);
  const [profile, setProfile] = useState<"admin" | "manager">("admin");
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());
  const [taskId, setTaskId] = useState<string | null>(null);

  // ✅ Only fetch when the modal opens
//   useEffect(() => {
//     if (!isOpen) return;

//     (async () => {
//       const supabase = supabaseUtils.createBrowserClient(cookies());

//       const { data: a } = await supabase.from("user_api").select("id");
//       const assignedIds = new Set(a?.map((r) => r.id));

//       const { data: all } = await supabase
//         .from("employees")
//         .select("id, first_name, last_name");

//       setEmployees((all ?? []).filter((e) => !assignedIds.has(e.id)));
//     })();
//   }, [isOpen]);

//   const toggleSelect = (id: string) => {
//     setSelectedIds((s) => {
//       const next = new Set(s);
//       next.has(id) ? next.delete(id) : next.add(id);
//       return next;
//     });
//   };
  const toggleSelect = (id: string) => {
    setSelectedIds((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    // fire off your async signup task
    // replace with your actual endpoint / RPC
    const res = await fetch("/api/start-user-signup", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        profile,
        user_ids: Array.from(selectedIds),
      }),
    });
    const { taskId: id } = await res.json();
    setTaskId(id);
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
            onClick={() => setIsOpen(false)}
          />
          <form
            onSubmit={handleSubmit}
            className="bg-white p-6 rounded-lg shadow-lg z-10 w-full max-w-lg space-y-4"
          >
            <h2 className="text-xl font-bold">Create New Users</h2>

            {/* Profile dropdown */}
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

            {/* Employee checklist */}
            <fieldset className="space-y-1">
              <legend>Employees without a user_api record</legend>
              {unassignedEmployees.length === 0 && (
                <p className="text-gray-500">All employees already users.</p>
              )}

              {unassignedEmployees.map((e) => (
                <label key={e.id} className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    checked={selectedIds.has(e.id)}
                    onChange={() => toggleSelect(e.id)}
                    className="form-checkbox"
                  />
                  {e.first_name} {e.last_name}
                </label>
              ))}
            </fieldset>

            {/* Submit & status */}
            <div className="flex items-center justify-between mt-4">
              <button
                type="submit"
                className="bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-4 rounded disabled:opacity-50"
                disabled={selectedIds.size === 0}
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
