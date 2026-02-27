"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import Image from "next/image";
import { usePathname } from "next/navigation";
import { Search, Bell, Menu, X } from "lucide-react";

export function Navbar() {
    const [isScrolled, setIsScrolled] = useState(false);
    const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
    const pathname = usePathname();

    useEffect(() => {
        const handleScroll = () => {
            if (window.scrollY > 0) {
                setIsScrolled(true);
            } else {
                setIsScrolled(false);
            }
        };

        window.addEventListener("scroll", handleScroll);
        return () => window.removeEventListener("scroll", handleScroll);
    }, []);

    const navLinks = [
        { name: "Home", href: "/" },
        { name: "Live TV", href: "/live-tv" },
        { name: "Movies", href: "/movies" },
        { name: "News", href: "/news" },
    ];

    if (pathname.startsWith("/watch")) return null;

    return (
        <nav
            className={`fixed top-4 md:top-6 left-1/2 -translate-x-1/2 w-[95%] max-w-7xl z-50 transition-all duration-500 ease-in-out rounded-2xl md:rounded-[2rem] border overflow-hidden ${isScrolled
                ? "bg-neutral-900/70 backdrop-blur-xl border-white/10 shadow-[0_10px_30px_rgba(0,0,0,0.8)] py-1 max-w-[90%]"
                : "bg-black/20 backdrop-blur-md border-transparent shadow-none py-2 md:py-3"
                }`}
        >
            <div className="px-4 md:px-8 w-full">
                <div className="flex items-center justify-between h-12 md:h-16">
                    {/* Logo & Desktop Nav */}
                    <div className="flex items-center space-x-8">
                        <Link href="/" className="flex items-center">
                            <div className="relative w-12 h-12 md:w-16 md:h-16 rounded overflow-hidden shadow-lg group">
                                <Image
                                    src="/logo.png"
                                    alt="GospelVisionTV Logo"
                                    fill
                                    className="object-cover group-hover:scale-105 transition-transform duration-300"
                                />
                            </div>
                        </Link>

                        {/* Desktop Navigation */}
                        <div className="hidden md:flex space-x-6">
                            {navLinks.map((link) => {
                                const isActive = pathname === link.href;
                                return (
                                    <Link
                                        key={link.name}
                                        href={link.href}
                                        className={`text-sm font-semibold transition-colors duration-200 ${isActive
                                            ? "text-white drop-shadow-[0_0_8px_rgba(234,84,0,0.5)]" // primary-orange glow
                                            : "text-neutral-400 hover:text-white"
                                            }`}
                                    >
                                        {link.name}
                                    </Link>
                                );
                            })}
                        </div>
                    </div>

                    {/* Right Side Icons Desktop */}
                    <div className="hidden md:flex items-center space-x-6 text-white">
                        <button className="hover:text-amber-500 transition-colors">
                            <Search className="w-5 h-5" />
                        </button>
                        <span className="text-sm font-medium hover:text-amber-500 cursor-pointer transition-colors">
                            Kids
                        </span>
                        <button className="hover:text-amber-500 transition-colors">
                            <Bell className="w-5 h-5" />
                        </button>
                        <Link href="/login">
                            <div className="w-8 h-8 rounded bg-gradient-to-tr from-orange-600 to-amber-500 cursor-pointer overflow-hidden border border-neutral-700 hover:border-amber-400 transition-colors"></div>
                        </Link>
                    </div>

                    {/* Mobile menu button */}
                    <div className="md:hidden flex items-center">
                        <button
                            onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
                            className="text-white hover:text-amber-500 transition-colors"
                        >
                            {isMobileMenuOpen ? (
                                <X className="w-6 h-6" />
                            ) : (
                                <Menu className="w-6 h-6" />
                            )}
                        </button>
                    </div>
                </div>
            </div>

            {/* Mobile Navigation */}
            {isMobileMenuOpen && (
                <div className="md:hidden bg-[#050505] absolute w-full border-b border-neutral-800 shadow-xl">
                    <div className="px-4 pt-2 pb-6 space-y-2 flex flex-col items-center">
                        {navLinks.map((link) => (
                            <Link
                                key={link.name}
                                href={link.href}
                                className="block px-3 py-2 text-base font-medium text-neutral-300 hover:text-white hover:bg-white/5 rounded-md w-full text-center"
                                onClick={() => setIsMobileMenuOpen(false)}
                            >
                                {link.name}
                            </Link>
                        ))}
                        <div className="pt-4 border-t border-neutral-800 w-full flex justify-center space-x-6">
                            <Search className="w-6 h-6 text-white" />
                            <Bell className="w-6 h-6 text-white" />
                            <Link href="/login" onClick={() => setIsMobileMenuOpen(false)}>
                                <div className="w-8 h-8 rounded bg-gradient-to-tr from-orange-600 to-amber-500 cursor-pointer"></div>
                            </Link>
                        </div>
                    </div>
                </div>
            )}
        </nav>
    );
}
