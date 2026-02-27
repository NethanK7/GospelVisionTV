import { ContentModel } from "@/types";
import Image from "next/image";
import Link from "next/link";
import { Play, Info } from "lucide-react";

export function Banner({ movie }: { movie: ContentModel | null }) {
    if (!movie) {
        return (
            <header className="relative h-[65vh] md:h-[85vh] w-full flex flex-col justify-end pb-32 px-4 md:px-16 animate-pulse bg-neutral-900 border-b border-neutral-800" />
        );
    }

    const bgImage = movie.backdropUrl || movie.imageUrl;

    return (
        <header className="relative h-[65vh] md:h-[85vh] w-full border-b border-neutral-800/50">
            <div className="absolute top-0 left-0 w-full h-full -z-10 overflow-hidden">
                <Image
                    src={bgImage}
                    alt={movie.title}
                    fill
                    priority
                    sizes="100vw"
                    className="object-cover object-top animate-[hero-zoom_60s_linear_forwards]"
                />
                <div className="absolute inset-0 bg-gradient-to-r from-black/80 via-black/40 to-transparent" />
                <div className="absolute inset-x-0 bottom-0 h-40 bg-gradient-to-t from-[#050505] to-transparent" />
            </div>

            <div className="h-full flex flex-col items-center justify-center px-4 md:px-16 lg:px-24 relative z-10 pt-20">
                {movie.streamStatus === "live" && (
                    <div className="flex items-center space-x-2 mb-6 animate-pulse">
                        <div className="w-2 h-2 rounded-full bg-red-600 shadow-[0_0_10px_rgba(220,38,38,0.8)]"></div>
                        <span className="text-red-500 font-bold tracking-[0.3em] text-xs md:text-sm">LIVE NOW</span>
                    </div>
                )}
                {movie.isOriginal && !movie.streamStatus && (
                    <div className="flex items-center space-x-2 mb-4">
                        <span className="text-[#F29200] font-black text-sm md:text-lg tracking-[0.3em] drop-shadow-[0_2px_4px_rgba(0,0,0,0.8)]">
                            GOSPELVISION ORIGINAL
                        </span>
                    </div>
                )}

                {/* Centered Massive Title */}
                <h1 className="text-5xl md:text-7xl lg:text-[7rem] font-black tracking-tighter w-full max-w-5xl drop-shadow-[0_15px_30px_rgba(0,0,0,0.9)] leading-[1] text-white mb-6 uppercase text-center">
                    {movie.title}
                </h1>

                {/* Metadata */}
                <div className="flex items-center justify-center space-x-3 text-xs md:text-sm text-neutral-300 font-medium mb-6 flex-wrap leading-relaxed">
                    <span className="text-[#F29200] font-bold">{movie.isPremium ? "Premium" : "Free"}</span>
                    <span>•</span>
                    <span>{movie.genres.join(" • ")}</span>
                    {movie.contentRating && (
                        <>
                            <span>•</span>
                            <span className="border border-neutral-500 px-1.5 rounded-sm text-neutral-300">
                                {movie.contentRating}
                            </span>
                        </>
                    )}
                </div>

                <p className="w-full max-w-2xl text-sm md:text-base font-medium drop-shadow-lg text-neutral-200 line-clamp-2 md:line-clamp-3 mb-10 text-center">
                    {movie.description}
                </p>

                {/* Circular Radiating Play Button */}
                <div className="flex flex-col items-center space-y-6">
                    <Link href={`/watch/${movie.id}`}>
                        <div className="relative group cursor-pointer">
                            {/* Radiating outer glowing rings */}
                            <div className="absolute inset-0 rounded-full bg-[#EA5400] opacity-50 blur-xl group-hover:blur-2xl transition-all duration-500 animate-pulse"></div>

                            {/* Inner Button */}
                            <button className="relative flex items-center justify-center w-16 h-16 md:w-20 md:h-20 bg-gradient-to-br from-[#F29200] to-[#EA5400] rounded-full hover:scale-110 transition-transform duration-300 shadow-[0_0_30px_rgba(234,84,0,0.6)] border-2 border-white/20">
                                <Play className="w-8 h-8 md:w-10 md:h-10 fill-white text-white ml-1" />
                            </button>
                        </div>
                    </Link>

                    <button className="flex items-center justify-center space-x-2 bg-neutral-800/80 text-white font-medium px-6 py-2 rounded-full hover:bg-neutral-700 transition-colors shadow-md backdrop-blur-md border border-white/10 hover:border-white/30">
                        <Info className="w-5 h-5" strokeWidth={2} />
                        <span className="text-sm md:text-base tracking-wide">More Info</span>
                    </button>
                </div>
            </div>
        </header>
    );
}
