"use client";

import Link from "next/link";
import { Tv } from "lucide-react";

export function LiveTvRibbon() {
    return (
        <div className="relative w-full max-w-[95%] lg:max-w-7xl mx-auto mt-[-40px] md:mt-[-60px] mb-12 z-20">
            <Link href="/live-tv">
                <div className="relative overflow-hidden rounded-2xl md:rounded-[2rem] bg-gradient-to-br from-neutral-900 via-black to-[#0A0A0A] border border-white/10 shadow-[0_20px_40px_rgba(0,0,0,0.8)] group cursor-pointer hover:border-white/20 transition-all duration-500">

                    {/* Glowing Accent */}
                    <div className="absolute top-0 right-0 w-1/2 md:w-1/3 h-full bg-gradient-to-l from-[#EA5400]/20 to-transparent opacity-50 group-hover:opacity-100 transition-opacity duration-500 blur-2xl"></div>

                    <div className="relative px-6 py-6 md:px-12 md:py-10 flex flex-col md:flex-row items-center justify-between gap-8">

                        {/* Main Text & Badge */}
                        <div className="flex flex-col items-center md:items-start text-center md:text-left flex-1">
                            <div className="flex items-center space-x-3 mb-4">
                                <div className="flex items-center space-x-2 bg-red-600/10 border border-red-500/30 px-3 py-1 rounded-full">
                                    <div className="w-2 h-2 rounded-full bg-red-500 animate-pulse shadow-[0_0_10px_rgba(239,68,68,0.8)]"></div>
                                    <span className="text-red-500 font-bold text-xs tracking-widest uppercase">ON AIR</span>
                                </div>
                                <span className="text-neutral-400 font-medium text-xs md:text-sm tracking-wide uppercase">GospelVision Network</span>
                            </div>

                            <h2 className="text-2xl md:text-4xl lg:text-5xl font-black text-white tracking-tighter drop-shadow-md leading-[1.1]">
                                Worship & The Word <br className="hidden md:block" />
                                <span className="text-transparent bg-clip-text bg-gradient-to-r from-[#F29200] to-[#EA5400]">Live 24/7</span>
                            </h2>
                            <p className="text-neutral-400 font-medium text-sm md:text-base mt-4 max-w-lg leading-relaxed">
                                Join our global community streaming powerful sermons, deep worship, and uninterrupted faith-based broadcasting.
                            </p>
                        </div>

                        {/* Watch Live Button */}
                        <div className="shrink-0 relative group/btn">
                            <div className="absolute inset-0 bg-[#EA5400] rounded-full blur-xl opacity-40 group-hover/btn:opacity-80 transition-opacity duration-300"></div>
                            <button className="relative flex items-center justify-center space-x-3 bg-white text-black font-black px-8 py-3 md:px-10 md:py-4 rounded-full shadow-[0_10px_20px_rgba(0,0,0,0.5)] hover:scale-105 transition-transform duration-300">
                                <Tv className="w-5 h-5 md:w-6 md:h-6" strokeWidth={2.5} />
                                <span className="text-base md:text-lg tracking-wide uppercase">Tune In Now</span>
                            </button>
                        </div>

                    </div>
                </div>
            </Link>
        </div>
    );
}
