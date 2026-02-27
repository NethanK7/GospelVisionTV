export interface ContentModel {
    id: string;
    title: string;
    description: string;
    imageUrl: string;
    backdropUrl?: string; // High-res banner image
    videoUrl?: string;
    type: "movie" | "episode" | "live_stream";
    releaseDate?: string; // Release date or scheduled time for live
    duration?: number; // In minutes
    genres: string[];
    isPremium: boolean;
    isOriginal: boolean; // Is it a GospelVision Original?
    streamStatus?: "scheduled" | "live" | "ended";
    contentRating?: "G" | "PG" | "PG-13" | "TV-MA";
}

export type Category = "trending" | "new_releases" | "originals" | "kids" | "sermons" | "worship" | "all";
