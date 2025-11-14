# Frontend Design Skill

> Guides Claude to create richer, more unique frontend designs by mapping aesthetic improvements to implementable code.

## Overview

This skill helps avoid "distributional convergence" - the tendency for AI to generate generic designs (Inter fonts, purple gradients, minimal animations). Instead, create distinctive, thoughtfully designed interfaces.

## Core Principle

**Think like a frontend engineer:** Map aesthetic improvements to specific, implementable frontend code across typography, animations, backgrounds, and themes.

---

## Typography Guidelines

### Font Pairing Strategies

**Don't default to Inter.** Consider these font combinations:

1. **Modern & Clean:**
   - Headings: `font-family: 'Clash Display', 'Space Grotesk', or 'DM Sans'`
   - Body: `font-family: 'Inter', 'Public Sans', or 'Cabinet Grotesk'`

2. **Editorial & Sophisticated:**
   - Headings: `font-family: 'Fraunces', 'Playfair Display', or 'Crimson Pro'`
   - Body: `font-family: 'Source Serif Pro', 'Lora', or 'Spectral'`

3. **Tech & Bold:**
   - Headings: `font-family: 'JetBrains Mono', 'Syne', or 'Clash Display'`
   - Body: `font-family: 'IBM Plex Sans', 'Manrope', or 'DM Sans'`

### Typography Implementation

```css
/* Variable font weights for dynamic hierarchy */
h1 {
  font-weight: 700;
  font-size: clamp(2.5rem, 5vw, 4rem);
  line-height: 1.1;
  letter-spacing: -0.02em;
}

h2 {
  font-weight: 600;
  font-size: clamp(2rem, 4vw, 3rem);
  line-height: 1.2;
  letter-spacing: -0.01em;
}

/* Fluid typography */
body {
  font-size: clamp(1rem, 0.95rem + 0.25vw, 1.125rem);
  line-height: 1.6;
  letter-spacing: -0.005em;
}
```

---

## Animation Guidelines

### Move Beyond Basic Fades

**Principle:** Animations should feel purposeful and enhance user experience.

#### 1. Stagger Animations

```tsx
// For list items, cards, etc.
<motion.div
  initial={{ opacity: 0, y: 20 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{
    duration: 0.5,
    delay: index * 0.1, // Stagger effect
    ease: [0.22, 1, 0.36, 1], // Custom easing
  }}
>
  {content}
</motion.div>
```

#### 2. Micro-interactions

```tsx
// Button hover with scale and shadow
<motion.button
  whileHover={{
    scale: 1.02,
    boxShadow: '0 10px 30px rgba(0,0,0,0.15)'
  }}
  whileTap={{ scale: 0.98 }}
  transition={{ type: 'spring', stiffness: 400, damping: 17 }}
>
  Click me
</motion.button>
```

#### 3. Page Transitions

```tsx
// Smooth page enter/exit
<motion.div
  initial={{ opacity: 0, x: -20 }}
  animate={{ opacity: 1, x: 0 }}
  exit={{ opacity: 0, x: 20 }}
  transition={{ duration: 0.3 }}
>
  {page}
</motion.div>
```

#### 4. Scroll-triggered Animations

```tsx
// Reveal on scroll
<motion.div
  initial={{ opacity: 0, y: 50 }}
  whileInView={{ opacity: 1, y: 0 }}
  viewport={{ once: true, margin: '-100px' }}
  transition={{ duration: 0.6 }}
>
  {content}
</motion.div>
```

### CSS Animation Patterns

```css
/* Smooth hover elevations */
.card {
  transition: transform 0.3s cubic-bezier(0.22, 1, 0.36, 1),
              box-shadow 0.3s cubic-bezier(0.22, 1, 0.36, 1);
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

/* Skeleton loading states */
@keyframes shimmer {
  0% { background-position: -1000px 0; }
  100% { background-position: 1000px 0; }
}

.skeleton {
  background: linear-gradient(
    90deg,
    #f0f0f0 0%,
    #f8f8f8 50%,
    #f0f0f0 100%
  );
  background-size: 1000px 100%;
  animation: shimmer 2s infinite;
}
```

---

## Background Effects

### Beyond Purple Gradients

#### 1. Mesh Gradients

```css
background:
  radial-gradient(at 40% 20%, hsla(28,100%,74%,1) 0px, transparent 50%),
  radial-gradient(at 80% 0%, hsla(189,100%,56%,1) 0px, transparent 50%),
  radial-gradient(at 0% 50%, hsla(355,100%,93%,1) 0px, transparent 50%),
  radial-gradient(at 80% 50%, hsla(340,100%,76%,1) 0px, transparent 50%),
  radial-gradient(at 0% 100%, hsla(22,100%,77%,1) 0px, transparent 50%);
```

#### 2. Noise Texture

```css
background:
  url("data:image/svg+xml,%3Csvg viewBox='0 0 400 400' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)'/%3E%3C/svg%3E"),
  linear-gradient(to bottom right, #1a1a2e, #16213e);
background-blend-mode: overlay;
opacity: 0.05;
```

#### 3. Animated Grid

```css
background-image:
  linear-gradient(rgba(255,255,255,0.05) 1px, transparent 1px),
  linear-gradient(90deg, rgba(255,255,255,0.05) 1px, transparent 1px);
background-size: 50px 50px;
animation: grid-move 20s linear infinite;

@keyframes grid-move {
  0% { background-position: 0 0; }
  100% { background-position: 50px 50px; }
}
```

#### 4. Glassmorphism

```css
background: rgba(255, 255, 255, 0.1);
backdrop-filter: blur(10px) saturate(180%);
border: 1px solid rgba(255, 255, 255, 0.2);
box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
```

---

## Theme & Color Guidelines

### Color Palette Strategies

**Don't default to purple/blue.** Consider:

#### 1. Warm & Energetic
```css
--primary: #ff6b35;    /* Coral */
--secondary: #f7931e;  /* Orange */
--accent: #fec601;     /* Yellow */
--dark: #004e89;       /* Navy */
```

#### 2. Nature & Calm
```css
--primary: #2d6a4f;    /* Forest Green */
--secondary: #52b788;  /* Sage */
--accent: #95d5b2;     /* Mint */
--dark: #1b4332;       /* Deep Green */
```

#### 3. Bold & Modern
```css
--primary: #e63946;    /* Red */
--secondary: #1d3557;  /* Navy */
--accent: #f1faee;     /* Off-white */
--dark: #457b9d;       /* Steel Blue */
```

#### 4. Monochrome with Accent
```css
--primary: #111111;    /* Near Black */
--secondary: #666666;  /* Gray */
--accent: #00ff00;     /* Neon Green */
--light: #f5f5f5;      /* Light Gray */
```

### Implementation

```css
:root {
  /* Use HSL for easier manipulation */
  --primary-h: 220;
  --primary-s: 70%;
  --primary-l: 50%;

  --primary: hsl(var(--primary-h), var(--primary-s), var(--primary-l));
  --primary-dark: hsl(var(--primary-h), var(--primary-s), calc(var(--primary-l) - 10%));
  --primary-light: hsl(var(--primary-h), var(--primary-s), calc(var(--primary-l) + 10%));
}

/* Dark mode */
@media (prefers-color-scheme: dark) {
  :root {
    --primary-l: 60%; /* Lighter in dark mode */
  }
}
```

---

## Component Design Patterns

### Cards with Depth

```tsx
<div className="group relative overflow-hidden rounded-2xl bg-white p-6 shadow-lg transition-all hover:shadow-2xl">
  {/* Gradient border effect */}
  <div className="absolute inset-0 rounded-2xl bg-gradient-to-r from-blue-500 to-purple-500 opacity-0 transition-opacity group-hover:opacity-100"
       style={{ padding: '2px' }}>
    <div className="h-full w-full rounded-2xl bg-white" />
  </div>

  {/* Content */}
  <div className="relative z-10">
    {content}
  </div>
</div>
```

### Hero Sections

```tsx
<section className="relative min-h-screen overflow-hidden">
  {/* Animated background */}
  <div className="absolute inset-0 -z-10">
    <div className="absolute inset-0 bg-gradient-to-br from-indigo-500 via-purple-500 to-pink-500 opacity-90" />
    <div className="absolute inset-0 bg-[url('/grid.svg')] opacity-20" />
  </div>

  {/* Content with stagger animation */}
  <div className="container mx-auto px-4 pt-32">
    <motion.h1
      initial={{ opacity: 0, y: 30 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.6 }}
      className="text-6xl font-bold text-white"
    >
      {title}
    </motion.h1>

    <motion.p
      initial={{ opacity: 0, y: 30 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.6, delay: 0.2 }}
      className="mt-6 text-xl text-white/90"
    >
      {description}
    </motion.p>
  </div>
</section>
```

---

## Quick Decision Guide

When designing a component, ask:

1. **Typography:** Does this need a unique font pairing, or is Inter appropriate?
2. **Animation:** What user action triggers this? How can animation reinforce it?
3. **Background:** Does a gradient add meaning, or is it decorative noise?
4. **Color:** Does this palette match the brand personality and content?

## Anti-Patterns to Avoid

- ❌ Generic purple/blue gradients without reason
- ❌ Inter font for everything
- ❌ Only basic fade animations
- ❌ Flat designs without depth or hierarchy
- ❌ Animations that don't serve a purpose
- ❌ Color schemes that don't match content tone

## When to Use This Skill

- Creating landing pages
- Building marketing sites
- Designing hero sections
- Implementing component libraries
- Any UI that needs to stand out from generic templates

## Additional Resources

- **Fonts:** [Google Fonts](https://fonts.google.com), [Fontsource](https://fontsource.org)
- **Colors:** [Coolors](https://coolors.co), [Palettte App](https://palettte.app)
- **Animations:** [Framer Motion](https://www.framer.com/motion), [Auto Animate](https://auto-animate.formkit.com)
- **Inspiration:** [Awwwards](https://www.awwwards.com), [Dribbble](https://dribbble.com)
