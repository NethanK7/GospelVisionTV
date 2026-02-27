import { fetchTrending, fetchOriginals } from "@/lib/api";
import { VideoCard } from "@/components/VideoCard";
import Image from "next/image";

export default async function Movies() {
    const [trending, originals] = await Promise.all([
        fetchTrending(),
        fetchOriginals(),
    ]);

    const allMovies = [...trending, ...originals].filter(
        (m) => m.type === "movie" || m.type === "episode" // Treating both as general content for now
    );

    // Use the top trending movie for the massive background
    const heroMovie = trending[0];

    return (
        <main className="min-h-screen bg-[#050505] pb-24 relative">
            {/* Massive Cinematic Background */}
            <div className="absolute top-0 left-0 w-full h-[60vh] md:h-[70vh] z-0 overflow-hidden">
                {heroMovie && (
                    <>
                        <Image
                            src={heroMovie.backdropUrl || heroMovie.imageUrl}
                            alt="Background"
                            fill
                            priority
                            className="object-cover object-top opacity-50 animate-[hero-zoom_60s_linear_forwards]"
                        />
                        <div className="absolute inset-0 bg-gradient-to-b from-black/80 via-[#050505]/60 to-[#050505]" />
                        <div className="absolute inset-x-0 bottom-0 h-40 bg-gradient-to-t from-[#050505] to-transparent" />
                    </>
                )}
            </div>

            <div className="relative z-10 pt-32 md:pt-48 px-4 md:px-16 container mx-auto">
                <div className="flex flex-col mb-16 space-y-6">
                    <h1 className="text-5xl md:text-7xl lg:text-[6rem] font-black uppercase text-white tracking-tighter drop-shadow-[0_10px_20px_rgba(0,0,0,0.8)] leading-[1] text-center md:text-left">
                        Movies <span className="text-[#EA5400]">&</span> Series
                    </h1>

                    <div className="flex space-x-3 md:space-x-4 overflow-x-auto scrollbar-hide pb-4 pt-2 md:justify-start justify-center">
                        {["All", "Sermons", "Faith-Based", "Kids", "Worship"].map((category) => (
                            <button
                                key={category}
                                className={`px-6 py-2 rounded-full text-sm md:text-base font-bold transition-all duration-300 whitespace-nowrap shadow-lg backdrop-blur-md border ${category === "All"
                                    ? "bg-white text-black border-white shadow-[0_0_20px_rgba(255,255,255,0.4)] hover:scale-105"
                                    : "bg-white/10 text-white border-white/20 hover:bg-white/20 hover:border-white/40 hover:shadow-[0_0_15px_rgba(255,255,255,0.2)]"
                                    }`}
                            >
                                {category}
                            </button>
                        ))}
                    </div>
                </div>
            </div>

            <div className="relative z-10 container mx-auto px-4 md:px-16">
                <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-x-4 md:gap-x-6 gap-y-12">
                    {allMovies.map((movie) => (
                        <div key={movie.id} className="flex justify-center">
                            <VideoCard movie={movie} />
                        </div>
                    ))}
                </div>
            </div>
        </main >
    );
}
