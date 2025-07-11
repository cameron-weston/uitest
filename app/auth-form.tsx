"use client";
import { useRouter } from "next/navigation";
import { cn } from "@/lib/utils";
import { Label } from "../components/ui/label";
import { Input } from "../components/ui/input";
import { Button } from "../components/ui/button";
import React from "react";
import { Icons } from "../components/ui/icons";
import { useForm } from "react-hook-form";
import { createBrowserClient } from "@supabase/ssr";
import { debug } from "console";

interface IFormInput {
  email: string;
  password: string;
}
interface AuthFormProps extends React.HTMLAttributes<HTMLDivElement> {}

export default function AuthForm({ className, ...props }: AuthFormProps) {
  const supabase = createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );

  const [isLoading, setIsLoading] = React.useState<boolean>(false);
  const { register, handleSubmit } = useForm<IFormInput>();
  const router = useRouter();
  const onSubmit = handleSubmit(async (data) => {
    setIsLoading(true);

    const { data: signInData, error } = await supabase.auth.signInWithPassword({
      email: data.email,
      password: data.password,
    });

    setIsLoading(false);

    if (error) alert(error.message);
    // push to home page
    router.push("/employee");
  });

  return (
    <div className={cn("grid gap-6", className)} {...props}>
      <form onSubmit={onSubmit}>
        <div className="grid gap-2">
          <div className="grid gap-1">
            <Label className="sr-only" htmlFor="email">
              Email
            </Label>
            <Input
              {...register("email")}
              id="email"
              placeholder="name@example.com"
              type="email"
              autoCapitalize="none"
              autoComplete="email"
              autoCorrect="off"
              disabled={isLoading}
            />
            <Input
              {...register("password")}
              id="password"
              type="password"
              autoCapitalize="none"
              autoComplete="email"
              autoCorrect="off"
              disabled={isLoading}
            />
          </div>
          <Button disabled={isLoading}>
            {isLoading && (
              <Icons.spinner className="mr-2 h-4 w-4 animate-spin" />
            )}
            Sign In
          </Button>
        </div>
      </form>
    </div>
  );
}
