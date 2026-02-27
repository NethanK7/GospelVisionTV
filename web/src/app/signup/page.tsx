"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";

export default function Signup() {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [name, setName] = useState("");
    const [error, setError] = useState("");
    const router = useRouter();

    const handleSignup = (e: React.FormEvent) => {
        e.preventDefault();
        if (!email || !password || !name) {
            setError("Please fill out all fields.");
            return;
        }
        setError("");
        // Simulate Signup token storage
        localStorage.setItem("token", "dummy-jwt-token-789");
        router.push("/subscription");
    };

    return (
        <div className="relative flex min-h-screen flex-col items-center justify-center -mt-20">
            {/* Background Dim */}
            <div className="absolute inset-0 -z-10 bg-[url('https://image.tmdb.org/t/p/original/uDgy6hyPd82kRVc6OymCNcwO2K0.jpg')] bg-cover bg-center brightness-50 opacity-50" />
            <div className="absolute inset-0 -z-10 bg-black/60" />

            <form
                onSubmit={handleSignup}
                className="w-full max-w-md rounded-lg bg-black/80 px-10 py-16 backdrop-blur-sm border border-neutral-800 shadow-2xl"
            >
                <h1 className="mb-6 text-3xl font-bold text-white">Create Account</h1>
                {error && <p className="mb-4 text-sm text-[#EA5400] font-medium">{error}</p>}

                <div className="space-y-4">
                    <input
                        type="text"
                        placeholder="Full Name"
                        className="w-full rounded bg-[#333333] px-4 py-3.5 text-white placeholder-neutral-400 outline-none focus:bg-[#454545] transition-colors"
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                    />
                    <input
                        type="email"
                        placeholder="Email address"
                        className="w-full rounded bg-[#333333] px-4 py-3.5 text-white placeholder-neutral-400 outline-none focus:bg-[#454545] transition-colors"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                    />
                    <input
                        type="password"
                        placeholder="Create Password"
                        className="w-full rounded bg-[#333333] px-4 py-3.5 text-white placeholder-neutral-400 outline-none focus:bg-[#454545] transition-colors"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                    />
                </div>

                <button
                    type="submit"
                    className="mt-8 w-full rounded bg-[#EA5400] py-3.5 font-bold text-white hover:bg-orange-600 transition-colors shadow-lg"
                >
                    Sign Up
                </button>

                <div className="mt-16 text-neutral-400">
                    Already have an account?{" "}
                    <Link href="/login" className="text-white hover:underline">
                        Sign in here.
                    </Link>
                </div>
            </form>
        </div>
    );
}
