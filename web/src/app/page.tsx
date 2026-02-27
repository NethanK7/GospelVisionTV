import { Banner } from "@/components/Banner";
import { Row } from "@/components/Row";
import { LiveTvRibbon } from "@/components/LiveTvRibbon";
import { fetchTrending, fetchOriginals } from "@/lib/api";

export default async function Home() {
  const [trending, originals] = await Promise.all([
    fetchTrending(),
    fetchOriginals(),
  ]);

  // Use the first original item as the hero banner, fallback to trending.
  const bannerHero = originals.length > 0 ? originals[0] : trending[0];

  return (
    <main className="relative pb-24 bg-[#050505]">
      {/* Cinematic Hero */}
      <Banner movie={bannerHero} />

      {/* Dedicated Live TV Ribbon Gateway */}
      <LiveTvRibbon />

      {/* Rows Container */}
      <section className="relative z-10 flex flex-col space-y-12">
        <Row title="Trending Now" movies={trending} />
        <Row title="GospelVision Originals" movies={originals} isLargeRow={true} />

        {/* Placeholder Categories for future implementation */}
        <Row title="Faith-Based Movies" movies={trending.filter((m) => m.type === "movie")} />
        <Row title="Powerful Sermons" movies={originals} />
        <Row title="Kids Collection" movies={trending} />
      </section>
    </main>
  );
}
