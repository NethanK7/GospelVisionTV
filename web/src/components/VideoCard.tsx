"use client";

import { ContentModel } from "@/types";
import Image from "next/image";
import Link from "next/link";
import { Play, Plus, ThumbsUp, ChevronDown } from "lucide-react";

interface VideoCardProps {
    movie: ContentModel;
    isLargeRow?: boolean;
    onClick?: () => void;
}

export function VideoCard({ movie, isLargeRow = false, onClick }: VideoCardProps) {
    // Use high-res backdrop if it's a large row, otherwise poster image
    const displayImage = isLargeRow ? movie.backdropUrl || movie.imageUrl : movie.imageUrl;

    const innerContent = (
        <div className="relative w-full aspect-[16/9] bg-neutral-900">
            <Image
                src={displayImage}
                alt={movie.title}
                fill
                sizes={isLargeRow ? "(max-width: 768px) 240px, 400px" : "(max-width: 768px) 120px, 220px"}
                className="object-cover transition-transform duration-500 group-hover:scale-105"
            />
            {/* Top Left Badges */}
            <div className="absolute top-2 left-2 flex gap-1">
                {movie.streamStatus === "live" && (
                    <div className="bg-red-600 px-1.5 py-0.5 rounded text-[8px] font-black uppercase text-white shadow-md animate-pulse">
                        LIVE
                    </div>
                )}
                {movie.isPremium && (
                    <div className="bg-amber-500/90 backdrop-blur px-1.5 py-0.5 rounded text-[8px] font-black uppercase text-black shadow-md">
                        Premium
                    </div>
                )}
            </div>

            {/* Astra-style Internal Details Hover Overlay */}
            <div className="absolute inset-x-0 bottom-0 bg-neutral-900/80 backdrop-blur-xl border-t border-white/10 p-3 md:p-4 translate-y-full group-hover:translate-y-0 opacity-0 group-hover:opacity-100 transition-all duration-300 shadow-[0_-10px_20px_rgba(0,0,0,0.8)] z-20 flex flex-col">
                <div className="flex items-center justify-between mb-2">
                    <div className="flex space-x-2">
                        <div className="bg-white rounded-full p-1.5 hover:bg-neutral-300 transition-colors cursor-pointer">
                            <Play className="w-3 h-3 md:w-4 md:h-4 fill-black text-black" />
                        </div>
                        <div className="border border-neutral-500 rounded-full p-1.5 hover:border-white transition-colors cursor-pointer text-white hidden md:block">
                            <Plus className="w-3 h-3 md:w-4 md:h-4" />
                        </div>
                        <div className="border border-neutral-500 rounded-full p-1.5 hover:border-white transition-colors cursor-pointer text-white hidden md:block">
                            <ThumbsUp className="w-3 h-3 md:w-4 md:h-4" />
                        </div>
                    </div>
                    {onClick && (
                        <div className="border border-neutral-500 rounded-full p-1.5 hover:border-white hover:bg-neutral-800 transition-colors cursor-pointer text-white">
                            <ChevronDown className="w-3 h-3 md:w-4 md:h-4" />
                        </div>
                    )}
                </div>

                <p className="text-white font-bold text-xs md:text-sm line-clamp-1 w-full mb-1">{movie.title}</p>
                <div className="flex items-center space-x-2 text-[8px] md:text-[10px] font-semibold">
                    <span className="text-[#46d369]">98% Match</span>
                    {movie.contentRating && (
                        <span className="border border-neutral-500 px-1 rounded-sm text-neutral-300">{movie.contentRating}</span>
                    )}
                </div>
                <p className="text-neutral-400 font-medium text-[8px] md:text-[10px] line-clamp-1 w-full mt-1.5 hidden md:block">
                    {movie.genres.join(" • ")}
                </p>
            </div>
        </div>
    );

    const wrapperClasses = `relative group shrink-0 overflow-hidden rounded-xl md:rounded-2xl transition-all duration-500 transform bg-neutral-900 cursor-pointer 
      ${isLargeRow ? "w-[240px] md:w-[320px] lg:w-[400px]" : "w-[120px] md:w-[160px] lg:w-[220px]"}
      hover:-translate-y-2 hover:z-10 focus-visible:-translate-y-2 focus-visible:z-10 focus-visible:outline-white
      shadow-[0_4px_10px_rgba(0,0,0,0.5)] hover:shadow-[0_20px_40px_rgba(234,84,0,0.3)] ring-1 ring-white/5 hover:ring-white/20`;

    if (onClick) {
        return (
            <div onClick={onClick} className={wrapperClasses}>
                {innerContent}
            </div>
        );
    }

    return (
        <div className={wrapperClasses}>
            <Link href={`/watch/${movie.id}`}>
                {innerContent}
            </Link>
        </div>
    );
}
