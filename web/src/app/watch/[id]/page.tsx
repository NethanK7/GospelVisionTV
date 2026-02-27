"use client";

import { fetchVideoDetails } from "@/lib/api";
import { ArrowLeft } from "lucide-react";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { ContentModel } from "@/types";
import { use } from "react";

export default function Watch({ params }: { params: Promise<{ id: string }> }) {
    const router = useRouter();
    const [movie, setMovie] = useState<ContentModel | null>(null);
    const resolvedParams = use(params);

    useEffect(() => {
        async function load() {
            const data = await fetchVideoDetails(resolvedParams.id);
            setMovie(data);
        }
        load();
    }, [resolvedParams.id]);

    if (!movie) {
        return (
            <div className="flex h-screen w-full items-center justify-center bg-black">
                <div className="h-16 w-16 animate-spin rounded-full border-4 border-[#EA5400] border-t-transparent"></div>
            </div>
        );
    }

    // Uses a placeholder video if none is provided
    const videoSource = movie.videoUrl || "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4";

    return (
        <div className="relative h-screen w-full bg-black group/player overflow-hidden">
            {/* Floating Glass Pill Navigation */}
            <nav className="absolute top-6 left-6 z-50 flex items-center gap-4 bg-neutral-900/60 backdrop-blur-xl border border-white/10 px-5 py-3 rounded-full shadow-[0_10px_30px_rgba(0,0,0,0.5)] transform -translate-y-4 opacity-0 group-hover/player:translate-y-0 group-hover/player:opacity-100 transition-all duration-500 ease-out">
                <ArrowLeft
                    className="h-8 w-8 cursor-pointer text-white hover:text-[#EA5400] hover:scale-110 transition-all"
                    onClick={() => router.back()}
                />
                <div className="h-6 w-px bg-white/20 mx-2"></div>
                <h1 className="text-white text-lg md:text-xl font-bold tracking-wide drop-shadow-md pr-4">{movie.title}</h1>
            </nav>

            <video
                className="h-full w-full object-contain focus:outline-none"
                autoPlay
                controls
                src={videoSource}
            >
                Your browser does not support HTML video.
            </video>
        </div>
    );
}
