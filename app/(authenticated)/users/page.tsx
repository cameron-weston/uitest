import AddUserModal from "./add-user-modal";
import { cookies, headers } from "next/headers";
import { UserRow, columns } from "./columns";
import { DataTable } from "../../../components/data-table";
import { PostgrestError } from "@supabase/supabase-js";
import { Database } from "@/types/supabase";
import { supabaseUtils } from "@/lib/utils";
import { Employee } from "../employee/columns";
export type DbResult<T> = T extends PromiseLike<infer U> ? U : never;
export type DbResultOk<T> = T extends PromiseLike<{ data: infer U }>
  ? Exclude<U, null>
  : never;
export type DbResultErr = PostgrestError;

type UsersTable = Database["public"]["Tables"]["user_api"]["Row"];
export type UnassignedEmployee = {
    id: string,
    first_name: string,
    last_name: string
}

async function getUsersData(): Promise<UserRow[]> {
  const supabase = supabaseUtils.createServerClient(cookies());

  const { data: testData, error: testError } = await supabase.rpc(
    "test_authorization_header"
  );
  console.log(
    `The user role is ${testData.role} and the user UUID is ${testData.sub}. `,
    testError
  );

  const usersQuery = supabase
    .from("user_api")
    .select(
      "id, name, email, profile"
    );
  const { data, error } = await usersQuery.returns<UsersTable[]>();
  if (error || !data) {
    console.error(error);
    return [];
  }

  return data.map((user) => {
    return {
      id: user.id,
      name: user.name,
      profile: user.profile
    };
  });
}

async function getEmployeesWithoutProfiles(): Promise<UnassignedEmployee[]> {
  const supabase = supabaseUtils.createServerClient(cookies());

  const { data, error } = await supabase
    .from('unassigned_employees')
    .select('id, first_name, last_name');

  if (error) {
    console.error('Error fetching unassigned employees:', error);
    return [];
  }

  return data ?? [];
}

export default async function UsersPage() {
  const data = await getUsersData();
  const unassignedEmployees = await getEmployeesWithoutProfiles();

  return (
    <div>
        <AddUserModal unassignedEmployees={unassignedEmployees}/>
        
        <div className="flex overflow-hidden justify-center">
        <DataTable columns={columns} data={data} />
        </div>
    </div>
  );
}
