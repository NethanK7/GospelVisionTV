import { ContentModel } from "@/types";

// const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000/api";

// Temporarily mock API calls until backend is connected.
const MOCK_DATA: ContentModel[] = [
    {
        id: "m01",
        title: "The Chosen Season 4 Premiere",
        description: "Witness the groundbreaking multi-season series about the life of Christ.",
        imageUrl: "https://images.unsplash.com/photo-1543794327-59a91fb815d6?q=80&w=800&auto=format&fit=crop",
        backdropUrl: "https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=2000&auto=format&fit=crop",
        type: "episode",
        genres: ["Drama", "Historical"],
        isPremium: true,
        isOriginal: false,
        contentRating: "TV-MA",
    },
    {
        id: "o01",
        title: "Grace & Truth Collection",
        description: "An exclusive GospelVision Original exploring the fundamental truths of scripture.",
        imageUrl: "https://images.unsplash.com/photo-1507924538820-ede94a04019d?q=80&w=800&auto=format&fit=crop",
        backdropUrl: "https://images.unsplash.com/photo-1518623489648-a173ef7824f3?q=80&w=2000&auto=format&fit=crop",
        type: "movie",
        genres: ["Documentary", "Educational"],
        isPremium: false,
        isOriginal: true,
    },
    {
        id: "l01",
        title: "GospelVision Live Main Event",
        description: "Join us for 24/7 continuous world-class Christian programming broadcasting globally.",
        imageUrl: "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=800&auto=format&fit=crop",
        backdropUrl: "https://images.unsplash.com/photo-1478147427282-58a871193282?q=80&w=2000&auto=format&fit=crop",
        type: "live_stream",
        genres: ["Live", "Worship", "Sermon"],
        isPremium: false,
        isOriginal: true,
        streamStatus: "live",
    },
];

export async function fetchTrending(): Promise<ContentModel[]> {
    try {
        // const res = await fetch(`${API_BASE_URL}/trending`, { next: { revalidate: 3600 } });
        // return res.json();
        return Promise.resolve(MOCK_DATA);
    } catch (error) {
        console.error("Error fetching trending data:", error);
        return [];
    }
}

export async function fetchOriginals(): Promise<ContentModel[]> {
    try {
        // const res = await fetch(`${API_BASE_URL}/originals`, { next: { revalidate: 3600 } });
        // return res.json();
        return Promise.resolve(MOCK_DATA.filter((m) => m.isOriginal));
    } catch (error) {
        console.error("Error fetching originals data:", error);
        return [];
    }
}

export async function fetchVideoDetails(id: string): Promise<ContentModel | null> {
    try {
        // const res = await fetch(`${API_BASE_URL}/videos/${id}`);
        // return res.json();
        const video = MOCK_DATA.find((m) => m.id === id);
        return Promise.resolve(video || null);
    } catch (error) {
        console.error(`Error fetching video ${id}:`, error);
        return null;
    }
}
