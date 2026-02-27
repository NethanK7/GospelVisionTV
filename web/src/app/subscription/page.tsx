import Link from 'next/link';

export default function SubscriptionPage() {
    return (
        <div className="min-h-screen bg-[#0A0A0A] bg-[radial-gradient(ellipse_at_top_right,_var(--tw-gradient-stops))] from-amber-900/10 via-[#0A0A0A] to-[#0A0A0A] flex flex-col items-center justify-center p-6">
            <div className="text-center mb-16 animate-fade-in">
                <h1 className="text-4xl md:text-5xl font-black text-white tracking-tight mb-4 drop-shadow-[0_0_15px_rgba(255,255,255,0.3)]">
                    Choose Your Plan
                </h1>
                <p className="text-white/60 text-lg max-w-lg mx-auto">
                    Unlock unlimited access to faith-based movies, live events, and exclusive originals.
                </p>
            </div>

            <div className="flex flex-col md:flex-row gap-8 items-center justify-center w-full max-w-5xl mb-24 animate-slide-up" style={{ animationDelay: '200ms', animationFillMode: 'both' }}>
                {/* Basic Plan */}
                <div className="w-full md:w-[350px] p-8 rounded-3xl bg-white/[0.03] border border-white/10 flex flex-col">
                    <h3 className="text-2xl font-bold text-white mb-4">Basic</h3>
                    <div className="flex items-baseline gap-1 mb-8">
                        <span className="text-5xl font-black text-white">$7.99</span>
                        <span className="text-white/50">/month</span>
                    </div>
                    <div className="flex flex-col gap-4 mb-8 flex-grow text-white/80">
                        <div className="flex items-center gap-3"><span className="text-white/40">✓</span> HD Streaming</div>
                        <div className="flex items-center gap-3"><span className="text-white/40">✓</span> 1 Device</div>
                        <div className="flex items-center gap-3"><span className="text-white/40">✓</span> Ad-supported</div>
                    </div>
                    <Link href="/movies" className="w-full py-4 text-center rounded-xl bg-white/10 text-white font-bold hover:bg-white/20 transition-colors">
                        Select Basic
                    </Link>
                </div>

                {/* Premium Plan */}
                <div className="w-full md:w-[350px] p-8 rounded-3xl bg-[#E85D04]/10 border-2 border-[#E85D04] shadow-[0_10px_40px_rgba(232,93,4,0.15)] flex flex-col relative transform md:-translate-y-4">
                    <div className="absolute -top-4 left-1/2 -translate-x-1/2 bg-gradient-to-r from-[#FF8C00] to-[#E85D04] text-white text-[10px] font-black tracking-widest px-4 py-1 rounded-full shadow-lg">
                        MOST POPULAR
                    </div>
                    <h3 className="text-2xl font-bold text-white mb-4">Premium</h3>
                    <div className="flex items-baseline gap-1 mb-8">
                        <span className="text-5xl font-black text-white">$14.99</span>
                        <span className="text-white/50">/month</span>
                    </div>
                    <div className="flex flex-col gap-4 mb-8 flex-grow text-white/90">
                        <div className="flex items-center gap-3"><span className="text-[#E85D04]">✓</span> 4K Streaming</div>
                        <div className="flex items-center gap-3"><span className="text-[#E85D04]">✓</span> 4 Devices</div>
                        <div className="flex items-center gap-3"><span className="text-[#E85D04]">✓</span> Offline Downloads</div>
                        <div className="flex items-center gap-3"><span className="text-[#E85D04]">✓</span> No Ads</div>
                    </div>
                    <Link href="/movies" className="w-full py-4 text-center rounded-xl bg-[#E85D04] text-white font-bold hover:bg-[#FF8C00] transition-colors shadow-lg">
                        Select Premium
                    </Link>
                </div>
            </div>

            {/* Developer Skip */}
            <div className="animate-fade-in" style={{ animationDelay: '600ms', animationFillMode: 'both' }}>
                <Link
                    href="/movies"
                    className="flex items-center gap-3 px-8 py-4 rounded-full bg-white/5 border border-white/10 text-white/60 hover:text-white/90 hover:bg-white/10 transition-all font-bold tracking-wide"
                >
                    <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
                    </svg>
                    Developer Skip →
                </Link>
            </div>
        </div>
    );
}
