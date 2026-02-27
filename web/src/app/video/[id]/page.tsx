import { fetchVideoDetails, fetchTrending } from "@/lib/api";
import Image from "next/image";
import Link from "next/link";
import { Play, Plus, ThumbsUp } from "lucide-react";
import { Row } from "@/components/Row";
import { notFound } from "next/navigation";

// Required in Next.js 15 for async components with dynamic params
interface PageProps {
    params: Promise<{ id: string }>;
}

export default async function VideoDetail({ params }: PageProps) {
    const resolvedParams = await params;
    const movie = await fetchVideoDetails(resolvedParams.id);
    const trending = await fetchTrending();

    if (!movie) {
        notFound();
    }

    const bgImage = movie.backdropUrl || movie.imageUrl;

    return (
        <main className="min-h-screen bg-[#050505] pb-24">
            {/* Cinematic Banner specifically for details */}
            <div className="relative h-[60vh] md:h-[80vh] w-full">
                <div className="absolute top-0 left-0 w-full h-full overflow-hidden">
                    <Image
                        src={bgImage}
                        alt={movie.title}
                        fill
                        priority
                        className="object-cover object-top animate-[hero-zoom_60s_linear_forwards]"
                    />
                    <div className="absolute inset-0 bg-gradient-to-r from-black/90 via-black/50 to-transparent" />
                    <div className="absolute inset-x-0 bottom-0 h-40 bg-gradient-to-t from-[#050505] to-transparent" />
                </div>

                <div className="absolute inset-0 flex flex-col justify-end pb-12 px-4 md:px-16 lg:px-24">
                    <h1 className="text-4xl md:text-6xl lg:text-[5rem] tracking-tighter uppercase font-black w-full max-w-4xl leading-[1.1] text-white mb-6 drop-shadow-[0_10px_20px_rgba(0,0,0,0.9)]">
                        {movie.title}
                    </h1>

                    <div className="flex flex-wrap items-center gap-4 mb-6">
                        <Link href={`/watch/${movie.id}`}>
                            <button className="flex items-center space-x-2 bg-white text-black font-bold px-8 py-3 rounded-md hover:bg-neutral-300 transition-all shadow-lg hover:shadow-[0_0_25px_rgba(255,255,255,0.5)]">
                                <Play className="w-5 h-5 fill-black" />
                                <span className="text-lg">Play</span>
                            </button>
                        </Link>

                        <button className="flex items-center justify-center bg-transparent border-2 border-neutral-500 rounded-full w-12 h-12 hover:border-white hover:bg-white/10 transition-all shadow-md hover:shadow-[0_0_20px_rgba(255,255,255,0.2)]">
                            <Plus className="w-6 h-6 text-white" />
                        </button>
                        <button className="flex items-center justify-center bg-transparent border-2 border-neutral-500 rounded-full w-12 h-12 hover:border-white hover:bg-white/10 transition-all shadow-md hover:shadow-[0_0_20px_rgba(255,255,255,0.2)]">
                            <ThumbsUp className="w-6 h-6 text-white" />
                        </button>
                    </div>

                    <div className="flex flex-col md:flex-row gap-8">
                        <div className="flex-1 max-w-2xl">
                            <div className="flex items-center space-x-3 text-sm md:text-base font-medium mb-4">
                                <span className="text-green-500 font-bold bg-green-500/10 px-2 py-0.5 rounded">98% Match</span>
                                <span className="text-neutral-300">2026</span>
                                {movie.contentRating && (
                                    <span className="border border-neutral-600 px-1.5 rounded-sm text-neutral-300 text-xs">
                                        {movie.contentRating}
                                    </span>
                                )}
                                {movie.duration && (
                                    <span className="text-neutral-300">{movie.duration}m</span>
                                )}
                                <span className="border border-neutral-600 px-1 rounded-sm text-neutral-400 text-[10px]">
                                    HD
                                </span>
                            </div>
                            <p className="text-sm md:text-lg text-neutral-200 leading-relaxed drop-shadow-md">
                                {movie.description}
                            </p>
                        </div>

                        <div className="flex-1 md:max-w-xs text-sm text-neutral-400 flex flex-col gap-3 font-medium">
                            <p>
                                <span className="text-neutral-600 cursor-default">Cast: </span>
                                <span className="hover:underline cursor-pointer">Jonathan Roumie</span>,
                                <span className="hover:underline cursor-pointer"> Shahar Isaac</span>,
                                <span className="hover:underline cursor-pointer"> Elizabeth Tabish</span>
                            </p>
                            <p>
                                <span className="text-neutral-600 cursor-default">Genres: </span>
                                {movie.genres.map((g, i) => (
                                    <span key={g}>
                                        <span className="hover:underline cursor-pointer">{g}</span>
                                        {i < movie.genres.length - 1 && ", "}
                                    </span>
                                ))}
                            </p>
                            <p>
                                <span className="text-neutral-600 cursor-default">This movie is: </span>
                                <span className="hover:underline cursor-pointer">Inspiring</span>,
                                <span className="hover:underline cursor-pointer"> Historical</span>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <div className="mt-12 container mx-auto">
                {/* Recommended Row using existing trending data */}
                <Row title="More Like This" movies={trending} />
            </div>
        </main>
    );
}
