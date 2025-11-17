# Brainstorm – PlatePilot

## Problem
College students often struggle to balance healthy eating with financial constraints. Many overspend on takeout due to poor planning, lack of meal knowledge, and limited time. They also lack awareness of nutrition, calorie intake, and ingredient organization, leading to unhealthy habits and wasted food and money.

## Solution
**PlatePilot** is a smart meal planning app designed for students to plan weekly meals based on budget and nutritional value. The app recommends affordable healthy recipes, generates grocery lists automatically, and tracks weekly spending and calorie progress to help users eat smarter and save more.

## Target Audience
- College students cooking for themselves
- Young adults who want affordable meal planning
- Users interested in improving diet, budgeting, and organization

## Core Features (MVP)
- Meal feed using external API (TheMealDB)
- Meal detail screen with ingredients, calories, and estimated cost
- Add meals to weekly planner (Mon–Sun)
- Auto-generated grocery list based on selected meals
- Weekly budget + nutrition dashboard summary
- Favorites screen and local persistence using UserDefaults / CoreData

## Stretch / Future Features
- Search bar + filtering (time, cost, diet)
- Dark mode option
- Push notifications / reminders
- Export grocery list to PDF or sharing tools
- AI-style recommendations based on preferences

## Value Proposition
- Saves money by reducing impulsive food spending
- Encourages healthier eating habits without complexity
- Improves organization and planning for busy student schedules
- Provides motivation through progress tracking

## Key Screens
1. Welcome / Onboarding
2. Home / Meal Feed
3. Meal Detail
4. Weekly Meal Planner
5. Grocery List
6. Budget & Nutrition Dashboard
7. Favorites
8. Profile / Settings

## Tech / Concepts Used
- UIKit + Storyboards
- Networking with URLSession
- TableViews & Navigation Controllers
- Passing data between screens
- Local persistence with UserDefaults/CoreData
- Delegation patterns and MVC architecture
- Git version control & sprint workflow

## Differentiation / Innovation
Unlike traditional meal planners, PlatePilot focuses on **students**, combining **budget awareness**, **nutrition insights**, and **automated grocery planning** with a clean interface and fast usability.

## How I reasoned for Project Scope
Scoped realistically for a 10-week development cycle with incremental sprints, focusing on a functioning MVP that can be extended later.
