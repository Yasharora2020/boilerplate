/** @type {import('next').NextConfig} */
const nextConfig = {
  // Required for Docker standalone build
  output: 'standalone',

  // Add your other Next.js config here
  reactStrictMode: true,

  // Example: Custom image domains
  // images: {
  //   domains: ['example.com'],
  // },

  // Example: Environment variables
  // env: {
  //   CUSTOM_KEY: process.env.CUSTOM_KEY,
  // },
}

module.exports = nextConfig
