# Aida - Interactive Medical Consultation Chatbot

A fully interactive AI-powered disease detection chatbot with a professional doctor-like conversation flow. Built with vanilla HTML/CSS/JS and Supabase backend.

## Features

- **Interactive Doctor Consultation** - Dr. Aida asks clarifying questions like a real doctor
- **100+ Diseases Database** - Comprehensive disease knowledge base
- **Duration-Based Treatment** - Day 1-3, Day 3-7, Day 7+ treatment plans
- **Red Flag Detection** - Emergency warnings for serious symptoms
- **Supabase Backend** - Cloud database with user authentication
- **LocalStorage Fallback** - Works offline without Supabase
- **Fully Responsive** - Beautiful design on all devices
- **Admin Panel** - View stats and manage diseases

## Quick Start

1. **Deploy to Vercel** (Recommended)
   - Push this repo to GitHub
   - Connect to Vercel
   - Deploy

2. **Set up Supabase** (Optional but recommended)
   - Create a Supabase project at https://supabase.com
   - Go to SQL Editor and run the `SUPABASE_SETUP.sql` file
   - Copy your Supabase URL and Anon Key
   - Update the `SUPABASE_URL` and `SUPABASE_ANON_KEY` in index.html

3. **Run Locally** (Without Supabase)
   - Just open index.html in a browser
   - It will work with localStorage fallback

## Dr. Aida Features

- Warm, professional doctor greeting
- Asks about symptoms, duration, severity, fever
- Duration-specific treatment plans
- Red flag detection (chest pain → ER, etc.)
- Blood cancer screening questions
- "Is there anything else?" at end of consultation
- Home remedies + exact medicine dosages

## Supabase Configuration

Update these in index.html:
```javascript
const SUPABASE_URL = "https://your-project.supabase.co";
const SUPABASE_ANON_KEY = "your-anon-key";
```

Then run `SUPABASE_SETUP.sql` in your Supabase SQL Editor.

## Tech Stack

- HTML5, CSS3 (Tailwind), Vanilla JavaScript
- Three.js (3D background)
- Supabase (Auth + Database)
- Vercel (Hosting)

## License

MIT - Educational use only. Not a substitute for professional medical advice.