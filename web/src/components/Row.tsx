"use client";

import { ContentModel } from "@/types";
import { VideoCard } from "./VideoCard";
import { useRef, useState, useEffect } from "react";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { useRouter } from "next/navigation";

interface RowProps {
    title: string;
    movies: ContentModel[];
    isLargeRow?: boolean;
}

export function Row({ title, movies, isLargeRow = false }: RowProps) {
    const rowRef = useRef<HTMLDivElement>(null);
    const [isHovered, setIsHovered] = useState(false);
    const [showLeftArrow, setShowLeftArrow] = useState(false);
    const router = useRouter();

    useEffect(() => {
        // Check if we need to show left arrow initially (unlikely on mount, but good practice)
        const handleScroll = () => {
            if (rowRef.current) {
                setShowLeftArrow(rowRef.current.scrollLeft > 0);
            }
        };
        const ref = rowRef.current;
        if (ref) {
            ref.addEventListener("scroll", handleScroll);
            handleScroll(); // Check once after render
        }
        return () => {
            if (ref) ref.removeEventListener("scroll", handleScroll);
        };
    }, []);

    const handleClick = (direction: "left" | "right") => {
        if (rowRef.current) {
            const { scrollLeft, clientWidth } = rowRef.current;
            // Scroll by 75% of the visible container width for a smooth chunk jump
            const scrollTo = direction === "left" ? scrollLeft - clientWidth * 0.75 : scrollLeft + clientWidth * 0.75;

            rowRef.current.scrollTo({
                left: scrollTo,
                behavior: "smooth",
            });
        }
    };

    if (!movies || movies.length === 0) return null;

    return (
        <div
            className="mb-8 relative group"
            onMouseEnter={() => setIsHovered(true)}
            onMouseLeave={() => setIsHovered(false)}
        >
            <h2 className="cursor-pointer text-sm font-bold text-[#e5e5e5] transition duration-200 hover:text-white md:text-xl lg:text-2xl mb-3 pl-4 md:pl-16 flex items-center group/title w-max max-w-full">
                {title}
                <span className="hidden md:flex opacity-0 group-hover/title:opacity-100 transition-opacity duration-300 items-center text-[#54b9c5] text-[10px] md:text-xs ml-3 font-semibold tracking-wider">
                    Explore All <ChevronRight className="w-3 h-3 md:w-4 md:h-4 ml-0.5" strokeWidth={3} />
                </span>
            </h2>

            <div className="relative">
                {/* Left Arrow */}
                <div
                    className={`absolute top-0 bottom-0 left-0 bg-black/50 z-20 w-8 md:w-16 flex items-center justify-center
            opacity-0 transition-all duration-300 ease-in-out hover:bg-black/80 hover:shadow-[0_0_30px_rgba(242,146,0,0.5)]
            ${isHovered && showLeftArrow ? "opacity-100" : ""}
          `}
                >
                    <ChevronLeft
                        className="h-9 w-9 text-white transition hover:scale-125 cursor-pointer"
                        onClick={() => handleClick("left")}
                    />
                </div>

                {/* Content Viewport */}
                <div
                    ref={rowRef}
                    className="flex items-center space-x-1 md:space-x-2.5 overflow-x-scroll scrollbar-hide pl-4 md:pl-16 pr-4 md:pr-16 py-4"
                    style={{ scrollbarWidth: "none", msOverflowStyle: "none" }} // Firefox & IE override
                >
                    {movies.map((movie) => (
                        <VideoCard
                            key={movie.id}
                            movie={movie}
                            isLargeRow={isLargeRow}
                            onClick={() => router.push(`/video/${movie.id}`)}
                        />
                    ))}
                </div>

                {/* Right Arrow */}
                <div
                    className={`absolute top-0 bottom-0 right-0 bg-black/50 z-20 w-8 md:w-16 flex items-center justify-center
            opacity-0 transition-all duration-300 ease-in-out hover:bg-black/80 hover:shadow-[0_0_30px_rgba(242,146,0,0.5)]
            ${isHovered ? "opacity-100" : ""}
          `}
                >
                    <ChevronRight
                        className="h-9 w-9 text-white transition hover:scale-125 cursor-pointer"
                        onClick={() => handleClick("right")}
                    />
                </div>
            </div>
        </div>
    );
}
