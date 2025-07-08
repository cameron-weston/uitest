"use client";

import { ColumnDef } from "@tanstack/react-table";

export type UserRow = {
  id: string;
  name: string;
  profile: string;
};

export const columns: ColumnDef<UserRow>[] = [
  {
    accessorKey: "name",
    header: "Name",
  },
  {
    accessorKey: "profile",
    header: "Profile",
    cell: ({ getValue }) => (
      <span className="capitalize font-medium">{getValue<string>()}</span>
    ),
  },
];

