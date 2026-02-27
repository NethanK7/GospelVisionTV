import { Play } from "lucide-react";
import Link from "next/link";

export default function LiveTV() {
    return (
        <main className="min-h-screen bg-[#050505] pt-32 md:pt-40 px-4 md:px-16 lg:px-24 pb-24">
            <div className="flex flex-col items-center text-center mb-16">
                <span className="text-[#EA5400] font-black uppercase tracking-[0.3em] text-sm mb-4">Live Broadcasting</span>
                <h1 className="text-5xl md:text-6xl font-black text-white tracking-tighter drop-shadow-md">
                    Global Stream Network
                </h1>
            </div>

            <div className="flex flex-col gap-16">
                {/* Main 24/7 Channel - Astra Zero-Edge Card */}
                <div className="relative w-full aspect-[16/9] md:aspect-[21/9] bg-[#0A0A0A] rounded-[2rem] md:rounded-[3rem] overflow-hidden group cursor-pointer border border-white/5 hover:border-white/20 transition-all duration-700 hover:shadow-[0_20px_50px_rgba(234,84,0,0.25)] ring-1 ring-transparent hover:ring-[#EA5400]/30 transform hover:-translate-y-2">
                    <Link href="/watch/l01" className="block w-full h-full relative">
                        {/* Background Image & Zoom */}
                        <div className="absolute inset-0 bg-[url('https://image.tmdb.org/t/p/original/kYgQzzjNis5jJalYtIOMN9uV1cK.jpg')] bg-cover bg-center opacity-60 group-hover:opacity-80 group-hover:scale-105 transition-all duration-700 ease-out" />

                        {/* Inner Vignette / Radial Glow */}
                        <div className="absolute inset-0 bg-radial-gradient from-transparent via-transparent to-[#050505]/90 pointer-events-none" />
                        <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/20 to-transparent pointer-events-none" />

                        {/* Live Indicator */}
                        <div className="absolute top-6 left-6 md:top-8 md:left-8 flex items-center space-x-3 bg-red-600/10 backdrop-blur-md px-4 py-2 rounded-full border border-red-500/30">
                            <div className="w-3 h-3 bg-red-500 rounded-full animate-pulse shadow-[0_0_15px_rgba(239,68,68,1)]" />
                            <span className="text-white text-sm md:text-base font-black tracking-widest uppercase">Live Now</span>
                        </div>

                        {/* Giant Radiating Play Button (Hidden until hover) */}
                        <div className="absolute inset-0 flex flex-col items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-300 transform group-hover:scale-110">
                            <div className="relative">
                                <div className="absolute inset-0 bg-[#EA5400] rounded-full blur-2xl opacity-60 animate-pulse"></div>
                                <div className="relative bg-gradient-to-br from-[#F29200] to-[#EA5400] w-20 h-20 md:w-28 md:h-28 rounded-full flex items-center justify-center shadow-[0_0_40px_rgba(234,84,0,0.8)] border-2 border-white/20">
                                    <Play className="w-10 h-10 md:w-14 md:h-14 text-white fill-white ml-2" />
                                </div>
                            </div>
                        </div>

                        {/* Bottom Info Gradient Area */}
                        <div className="absolute bottom-0 left-0 p-8 md:p-12 w-full flex flex-col justify-end">
                            <h2 className="text-4xl md:text-6xl font-black text-white drop-shadow-[0_5px_10px_rgba(0,0,0,0.8)] mb-4 leading-tight">
                                GospelVision <br className="hidden md:block" /> Main Server
                            </h2>
                            <p className="text-neutral-300 font-medium text-base md:text-lg max-w-3xl drop-shadow-md">
                                Broadcasting 24/7 powerful sermons, uplifting worship, and life-changing testimonies globally to believers worldwide.
                            </p>
                        </div>
                    </Link>
                </div>

                {/* Other Streams */}
                <div>
                    <div className="flex items-center justify-between mb-8">
                        <h3 className="text-2xl md:text-3xl font-bold text-white">Upcoming Broadcasts</h3>
                        <span className="text-neutral-400 text-sm font-semibold hover:text-white cursor-pointer transition-colors">View Schedule</span>
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 md:gap-8">
                        {[1, 2, 3].map((item) => (
                            <div key={item} className="group flex flex-col bg-[#0A0A0A] rounded-2xl overflow-hidden cursor-pointer border border-white/5 hover:border-white/20 transition-all duration-500 transform hover:-translate-y-2 hover:shadow-[0_15px_30px_rgba(234,84,0,0.15)] ring-1 ring-white/5 hover:ring-[#EA5400]/30">

                                <div className="aspect-video bg-neutral-900 border-b border-white/10 flex items-center justify-center relative overflow-hidden">
                                    <div className="absolute inset-0 bg-gradient-to-br from-white/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500 z-10" />
                                    <span className="text-neutral-600 font-black uppercase tracking-[0.2em] z-10">Transmission Empty</span>
                                </div>
                                <div className="p-6 md:p-8 flex-1 flex flex-col">
                                    <div className="flex justify-between items-start mb-4">
                                        <h4 className="text-xl font-bold text-white group-hover:text-[#F29200] transition-colors leading-snug">Sunday Service Live</h4>
                                        <span className="text-[10px] md:text-xs font-black text-[#F29200] bg-[#F29200]/10 px-2.5 py-1 rounded-full border border-[#F29200]/20 uppercase tracking-wider">Scheduled</span>
                                    </div>
                                    <p className="text-sm md:text-base text-neutral-400 font-medium leading-relaxed">Join the global congregation this Sunday at 10 AM EST for worship, prayer, and the reading of the Word.</p>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            </div>
        </main>
    );
}
