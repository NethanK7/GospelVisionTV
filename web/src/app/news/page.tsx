import Image from "next/image";

export default function News() {
    return (
        <main className="min-h-screen bg-[#050505] pt-32 md:pt-48 px-4 md:px-16 pb-24 relative overflow-hidden">
            {/* Ambient Background Glows */}
            <div className="absolute top-0 left-1/2 -translate-x-1/2 w-full max-w-4xl h-[400px] bg-gradient-radial from-[#EA5400]/10 to-transparent opacity-50 blur-[100px] pointer-events-none" />

            <div className="max-w-5xl mx-auto relative z-10">
                <div className="flex flex-col items-center text-center mb-16 md:mb-24">
                    <span className="text-[#EA5400] font-black uppercase tracking-[0.3em] text-sm mb-4">The Daily Word</span>
                    <h1 className="text-5xl md:text-7xl lg:text-[6rem] font-black text-white mb-6 leading-[1.1] tracking-tighter drop-shadow-[0_10px_20px_rgba(0,0,0,0.5)]">
                        Christian News <br className="hidden md:block" />
                        <span className="text-transparent bg-clip-text bg-gradient-to-r from-orange-400 to-amber-200">
                            & Devotionals
                        </span>
                    </h1>
                    <p className="text-neutral-400 text-lg md:text-xl max-w-2xl font-medium leading-relaxed">
                        Stay updated with global ministry events, the latest testimonies, and daily encouragement from around the world.
                    </p>
                </div>

                <div className="flex flex-col space-y-10">
                    {[1, 2, 3, 4].map((article) => (
                        <div key={article} className="group relative flex flex-col md:flex-row bg-[#0A0A0A] rounded-2xl overflow-hidden cursor-pointer border border-white/5 hover:border-white/20 transition-all duration-500 transform hover:-translate-y-2 hover:shadow-[0_20px_40px_rgba(234,84,0,0.15)] ring-1 ring-white/5 hover:ring-[#EA5400]/30">

                            {/* Inner Background Glow */}
                            <div className="absolute inset-0 bg-gradient-to-br from-white/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500" />

                            <div className="relative w-full md:w-[350px] shrink-0 h-56 md:h-auto bg-neutral-900 overflow-hidden">
                                <Image
                                    src={`https://image.tmdb.org/t/p/w780/yF1eOkaYvwiORauRCPWznV9xVvi.jpg`}
                                    alt="News thumbnail"
                                    fill
                                    className="object-cover group-hover:scale-105 transition-transform duration-700 ease-out"
                                />
                                <div className="absolute inset-0 bg-gradient-to-t from-[#0A0A0A]/80 to-transparent md:bg-gradient-to-r md:from-transparent md:to-[#0A0A0A] pointer-events-none" />
                            </div>

                            <div className="relative p-6 md:p-10 flex flex-col justify-center flex-1 z-10">
                                <span className="text-[#F29200] text-xs font-black uppercase tracking-[0.2em] mb-3">Ministry Update</span>
                                <h2 className="text-2xl md:text-3xl font-bold text-white mb-4 group-hover:text-transparent group-hover:bg-clip-text group-hover:bg-gradient-to-r group-hover:from-orange-400 group-hover:to-amber-200 transition-all duration-300 leading-snug drop-shadow-sm">
                                    Global Outreach Expands to New Territories in 2026
                                </h2>
                                <p className="text-neutral-400 text-sm md:text-base line-clamp-3 leading-relaxed mb-6 font-medium">
                                    Discover how new mission partnerships are bringing faith-based broadcasting to untouched regions, impacting thousands of lives with fresh testimonies and community support.
                                </p>
                                <div className="flex items-center text-xs text-neutral-500 font-bold uppercase tracking-wider space-x-4">
                                    <span>April 14, 2026</span>
                                    <span className="w-1.5 h-1.5 rounded-full bg-neutral-700"></span>
                                    <span className="text-[#EA5400]">5 Min Read</span>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            </div>
        </main>
    );
}
