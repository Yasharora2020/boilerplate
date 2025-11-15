# Next.js Development Patterns

Quick reference for Next.js development standards in this boilerplate.

## Version Requirement

**Use Next.js 15 or higher** for the latest features, improvements, and React 19 support.

## Setup

**Preferred Stack:**
```bash
# Ensure Next.js 15+
npx create-next-app@latest --typescript --tailwind --app --src-dir

# Install essentials
npm install zod @tanstack/react-query
npm install -D @testing-library/react @testing-library/jest-dom
```

**next.config.js:**
```javascript
const nextConfig = {
  output: 'standalone',        // Required for Docker
  reactStrictMode: true,
  images: {
    domains: ['your-cdn.com'],
    formats: ['image/avif', 'image/webp'],
  },
}
```

---

## App Router (Recommended)

**Use App Router for:**
- React Server Components by default (better performance)
- Improved layouts and nested routing
- Built-in loading/error states

**Structure:**
```
src/app/
├── layout.tsx           # Root layout
├── page.tsx             # Home page
├── loading.tsx          # Loading UI
├── error.tsx            # Error boundary
├── api/users/route.ts   # API routes
└── dashboard/
    ├── layout.tsx       # Nested layout
    └── page.tsx
```

---

## TypeScript Best Practices

**Strict typing with Zod validation:**
```typescript
import { z } from 'zod'

// Define schema
export const userSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8).regex(/[A-Z]/, 'Need uppercase'),
  name: z.string().min(2),
})

// Infer type
export type UserInput = z.infer<typeof userSchema>

// Validate
const result = userSchema.safeParse(data)
if (result.success) {
  const user = result.data  // Typed!
}
```

**Component props:**
```typescript
interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'default' | 'outline' | 'ghost'
  isLoading?: boolean
}

export function Button({ variant = 'default', isLoading, ...props }: ButtonProps) {
  return <button disabled={isLoading} {...props} />
}
```

---

## Server vs Client Components

**Server Components (default):**
```typescript
// app/users/page.tsx - No 'use client' needed
async function getUsers() {
  const res = await fetch('https://api.example.com/users', {
    next: { revalidate: 60 }  // ISR: revalidate every 60s
  })
  return res.json()
}

export default async function UsersPage() {
  const users = await getUsers()
  return <UserList users={users} />
}
```

**Client Components (when needed):**
```typescript
// components/counter.tsx
'use client'

import { useState } from 'react'

export function Counter() {
  const [count, setCount] = useState(0)
  return <button onClick={() => setCount(count + 1)}>{count}</button>
}
```

**Use Client Components for:**
- Hooks (useState, useEffect, etc.)
- Event listeners (onClick, onChange)
- Browser APIs (localStorage, window)
- React Context

---

## Data Fetching

**Server-side (preferred):**
```typescript
// Static generation (default)
async function getData() {
  const res = await fetch('https://api.example.com/data')
  return res.json()
}

// ISR (revalidate periodically)
await fetch(url, { next: { revalidate: 3600 } })

// Dynamic (no cache)
await fetch(url, { cache: 'no-store' })
```

**Client-side with React Query:**
```typescript
'use client'
import { useQuery } from '@tanstack/react-query'

function useUser(id: string) {
  return useQuery({
    queryKey: ['user', id],
    queryFn: () => fetch(`/api/users/${id}`).then(r => r.json()),
    staleTime: 5 * 60 * 1000,  // 5 min
  })
}
```

---

## Server Actions (Preferred for Mutations)

**Server Actions** are async functions that run on the server. Use them instead of API routes when possible for better performance and simpler code.

**Basic Server Action:**
```typescript
// app/actions.ts
'use server'

import { revalidatePath } from 'next/cache'
import { z } from 'zod'

const createUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2),
})

export async function createUser(formData: FormData) {
  // Validate input
  const validatedFields = createUserSchema.safeParse({
    email: formData.get('email'),
    name: formData.get('name'),
  })

  if (!validatedFields.success) {
    return {
      errors: validatedFields.error.flatten().fieldErrors,
    }
  }

  // Create user
  try {
    const user = await db.user.create({
      data: validatedFields.data,
    })

    revalidatePath('/users')
    return { success: true, user }
  } catch (error) {
    return { error: 'Failed to create user' }
  }
}
```

**Using Server Actions in Forms:**
```typescript
// app/users/new/page.tsx
import { createUser } from '@/app/actions'

export default function NewUserPage() {
  return (
    <form action={createUser}>
      <input name="email" type="email" required />
      <input name="name" type="text" required />
      <button type="submit">Create User</button>
    </form>
  )
}
```

**Server Actions with useFormState (for client components):**
```typescript
// components/user-form.tsx
'use client'

import { useFormState, useFormStatus } from 'react-dom'
import { createUser } from '@/app/actions'

function SubmitButton() {
  const { pending } = useFormStatus()
  return (
    <button type="submit" disabled={pending}>
      {pending ? 'Creating...' : 'Create User'}
    </button>
  )
}

export function UserForm() {
  const [state, formAction] = useFormState(createUser, null)

  return (
    <form action={formAction}>
      <input name="email" type="email" required />
      {state?.errors?.email && <p>{state.errors.email}</p>}

      <input name="name" type="text" required />
      {state?.errors?.name && <p>{state.errors.name}</p>}

      <SubmitButton />
      {state?.error && <p>{state.error}</p>}
    </form>
  )
}
```

**Server Actions with useTransition (programmatic calls):**
```typescript
'use client'

import { useTransition } from 'react'
import { deleteUser } from '@/app/actions'

export function DeleteButton({ userId }: { userId: string }) {
  const [isPending, startTransition] = useTransition()

  const handleDelete = () => {
    startTransition(async () => {
      await deleteUser(userId)
    })
  }

  return (
    <button onClick={handleDelete} disabled={isPending}>
      {isPending ? 'Deleting...' : 'Delete'}
    </button>
  )
}
```

**Server Action Best Practices:**
- Use `'use server'` directive at the top of the file or function
- Always validate input with Zod
- Use `revalidatePath()` or `revalidateTag()` to update cached data
- Return typed responses for better error handling
- Prefer Server Actions over API routes for mutations
- Use `redirect()` for navigation after successful mutations

---

## API Routes

```typescript
// app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server'
import { z } from 'zod'

const createUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2),
})

export async function GET() {
  const users = await db.user.findMany()
  return NextResponse.json(users)
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const data = createUserSchema.parse(body)

    const user = await db.user.create({ data })
    return NextResponse.json(user, { status: 201 })
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json({ errors: error.errors }, { status: 400 })
    }
    return NextResponse.json({ error: 'Server error' }, { status: 500 })
  }
}

// Dynamic route: app/api/users/[id]/route.ts
export async function GET(req: NextRequest, { params }: { params: { id: string } }) {
  const user = await db.user.findUnique({ where: { id: params.id } })
  if (!user) return NextResponse.json({ error: 'Not found' }, { status: 404 })
  return NextResponse.json(user)
}
```

---

## Styling with Tailwind

**Utility classes:**
```tsx
<div className="flex items-center gap-4 p-6 bg-white rounded-lg shadow-md">
  <h1 className="text-2xl font-bold text-gray-900">Title</h1>
</div>
```

**Conditional classes:**
```tsx
import { cn } from '@/lib/utils'  // clsx + tailwind-merge

<div className={cn(
  'base-class',
  isActive && 'active-class',
  className
)} />
```

---

## Performance

**Image optimization:**
```tsx
import Image from 'next/image'

<Image
  src="/avatar.jpg"
  alt="User avatar"
  width={40}
  height={40}
  priority={false}  // Only true for above-fold images
/>
```

**Code splitting:**
```tsx
import dynamic from 'next/dynamic'

const HeavyChart = dynamic(() => import('@/components/chart'), {
  loading: () => <p>Loading...</p>,
  ssr: false,  // Disable SSR if needed
})
```

**Metadata for SEO:**
```typescript
// app/layout.tsx
export const metadata: Metadata = {
  title: 'My App',
  description: 'App description',
}

// app/blog/[slug]/page.tsx
export async function generateMetadata({ params }): Promise<Metadata> {
  const post = await getPost(params.slug)
  return {
    title: post.title,
    description: post.excerpt,
  }
}
```

---

## Testing

```typescript
// __tests__/button.test.tsx
import { render, screen, fireEvent } from '@testing-library/react'
import { Button } from '@/components/ui/button'

describe('Button', () => {
  it('renders and handles clicks', () => {
    const handleClick = jest.fn()
    render(<Button onClick={handleClick}>Click me</Button>)

    fireEvent.click(screen.getByText('Click me'))
    expect(handleClick).toHaveBeenCalledTimes(1)
  })

  it('disables when loading', () => {
    render(<Button isLoading>Click me</Button>)
    expect(screen.getByRole('button')).toBeDisabled()
  })
})
```

---

## Security

**Environment variables:**
```bash
# .env.local (git-ignored)
DATABASE_URL="postgresql://..."
NEXT_PUBLIC_API_URL="https://api.example.com"  # Public vars need NEXT_PUBLIC_
```

**Validate env vars at startup:**
```typescript
// lib/env.ts
import { z } from 'zod'

const envSchema = z.object({
  DATABASE_URL: z.string().url(),
  NEXT_PUBLIC_API_URL: z.string().url(),
})

export const env = envSchema.parse(process.env)
```

**Input sanitization:**
```typescript
import DOMPurify from 'isomorphic-dompurify'

const sanitized = DOMPurify.sanitize(userInput)
```

**Security headers (next.config.js):**
```javascript
async headers() {
  return [{
    source: '/:path*',
    headers: [
      { key: 'X-Frame-Options', value: 'DENY' },
      { key: 'X-Content-Type-Options', value: 'nosniff' },
    ],
  }]
}
```

---

## Project Structure

```
src/
├── app/                 # Next.js routes
│   ├── api/            # API endpoints
│   └── (auth)/         # Route groups
├── components/
│   ├── ui/             # Reusable components
│   └── forms/
├── lib/                # Utils, API client, validations
├── hooks/              # Custom hooks
├── types/              # TypeScript types
└── config/             # App config
```

---

## Local Development

### Setup

```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Visit http://localhost:3000
```

### Testing

```bash
# Run tests
npm test

# Watch mode
npm test -- --watch

# Coverage
npm test -- --coverage
```

### Linting & Formatting

```bash
# Lint
npm run lint

# Format (if you use Prettier)
npm run format

# Type check
npm run type-check
```

---

## Quick Checklist

- [ ] Use Next.js 15 or higher
- [ ] Use App Router with Server Components by default
- [ ] Prefer Server Actions for mutations over API routes
- [ ] TypeScript strict mode enabled
- [ ] Zod for all runtime validation
- [ ] Next.js Image for all images
- [ ] Proper metadata for SEO
- [ ] Environment variables validated at startup
- [ ] API routes with proper error handling
- [ ] Tests for critical components
- [ ] Dynamic imports for heavy components
- [ ] Security headers configured

---

## Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [React Documentation](https://react.dev)
- [Zod Documentation](https://zod.dev)
- [Tailwind CSS](https://tailwindcss.com)
- [React Query Documentation](https://tanstack.com/query/latest)
