"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";

export default function Login() {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [error, setError] = useState("");
    const router = useRouter();

    const handleLogin = (e: React.FormEvent) => {
        e.preventDefault();
        if (!email || !password) {
            setError("Please enter a valid email and password.");
            return;
        }
        setError("");
        // Simulate Login token storage
        localStorage.setItem("token", "dummy-jwt-token-123");
        router.push("/subscription");
    };

    return (
        <div className="relative flex min-h-screen flex-col items-center justify-center -mt-20">
            {/* Background Dim */}
            <div className="absolute inset-0 -z-10 bg-[url('https://image.tmdb.org/t/p/original/tIqEEMmS8pIQXUvY8rQG6b8K8S2.jpg')] bg-cover bg-center brightness-50 opacity-50" />
            <div className="absolute inset-0 -z-10 bg-black/60" />

            <form
                onSubmit={handleLogin}
                className="w-full max-w-md rounded-lg bg-black/80 px-10 py-16 backdrop-blur-sm border border-neutral-800 shadow-2xl"
            >
                <h1 className="mb-6 text-3xl font-bold text-white">Sign In</h1>
                {error && <p className="mb-4 text-sm text-[#EA5400] font-medium">{error}</p>}

                <div className="space-y-4">
                    <input
                        type="email"
                        placeholder="Email or phone number"
                        className="w-full rounded bg-[#333333] px-4 py-3.5 text-white placeholder-neutral-400 outline-none focus:bg-[#454545] transition-colors"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                    />
                    <input
                        type="password"
                        placeholder="Password"
                        className="w-full rounded bg-[#333333] px-4 py-3.5 text-white placeholder-neutral-400 outline-none focus:bg-[#454545] transition-colors"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                    />
                </div>

                <button
                    type="submit"
                    className="mt-8 w-full rounded bg-[#EA5400] py-3.5 font-bold text-white hover:bg-orange-600 transition-colors shadow-lg"
                >
                    Sign In
                </button>

                <div className="mt-4 flex items-center justify-between text-sm text-neutral-400">
                    <label className="flex items-center">
                        <input type="checkbox" className="mr-2 accent-[#EA5400]" />
                        Remember me
                    </label>
                    <a href="#" className="hover:underline">
                        Need help?
                    </a>
                </div>

                <div className="mt-16 text-neutral-400">
                    New to GospelVision?{" "}
                    <Link href="/signup" className="text-white hover:underline">
                        Sign up now.
                    </Link>
                </div>
                <p className="mt-3 text-xs text-neutral-500">
                    This page is protected by Google reCAPTCHA to ensure you&apos;re not a bot.{" "}
                    <a href="#" className="text-blue-500 hover:underline">Learn more.</a>
                </p>
            </form>
        </div>
    );
}
