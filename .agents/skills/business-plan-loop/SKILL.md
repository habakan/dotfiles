---
name: business-plan-loop
description: Research and stress-test a business idea through iterative critical thinking, web research, market/competitor/customer validation, and business plan synthesis. Use when the user wants to evaluate a new business, refine a startup idea, create or update a business plan, compare competitors, answer objections such as "why not existing tool X?", or run loop-style venture validation with current internet research and Japanese outputs.
---

# Business Plan Loop

## Overview

Use this skill to run a loop-engineering style business planning process: clarify the idea, research the market, attack assumptions, update the hypothesis, and synthesize the result into a concise business plan.

Default to Japanese. Be direct and critical. Do not merely polish the user's idea; find why it may fail, what must be true, and what evidence is still missing.

## Core Loop

Run the following loop until the user asks to stop or the business plan is coherent enough for the requested artifact.

1. **Frame**
   - Restate the business in one sentence.
   - Identify the customer, job-to-be-done, current workaround, buying trigger, and expected budget owner.
   - List the riskiest assumptions before researching.

2. **Research**
   - Browse the web when facts may be current, market-specific, competitor-specific, regulatory, pricing-related, or useful for citations.
   - Prefer primary sources: official product pages, docs, pricing pages, filings, customer case studies, regulatory pages, reputable analyst or industry reports.
   - For competitor claims, inspect the competitor's own website before relying on summaries.
   - Keep direct quotes short and cite sources.

3. **Critique**
   - Attack the idea from customer, competition, distribution, pricing, adoption, security, legal, operational, and technical angles.
   - Ask "why now?", "why this team?", "why not existing tools?", "why would the buyer switch?", and "what budget does this replace?"
   - Separate evidence, inference, and open questions.

4. **Decide**
   - Recommend a concrete answer for each major fork.
   - Narrow the ICP and initial use case before expanding.
   - Prefer testable wedges over broad platform claims.

5. **Synthesize**
   - Update the plan with current conclusions, unresolved risks, and next validation actions.
   - If writing to a file, include date, assumptions, sources, and open questions.

See `references/framework.md` for the business plan structure, critique checklist, and output templates.

## Research Rules

- Browse the internet by default for market, competitor, pricing, regulations, recent product capabilities, or factual claims likely to change.
- Use official or primary sources whenever possible.
- Include source links in the final answer or generated document.
- If a source does not directly prove a conclusion, label the conclusion as an inference.
- Do not invent market sizes, prices, customer counts, or competitor features.
- When information is unavailable, write the exact research gap and how to validate it.

## Interview Style

Ask one or two high-leverage questions at a time only when the answer cannot be found through research or local files.

For each question:

- Explain why the question matters.
- Provide a recommended answer based on current evidence.
- Show the decision dependency that follows from the answer.

Do not get stuck asking questions. When reasonable, make an explicit assumption and continue.

## Output Standards

Business plan outputs should normally include:

- One-line thesis
- Target customer and ICP
- Problem and current workaround
- Initial use case
- Product wedge
- Differentiation and competitor response
- Business model
- Go-to-market
- Risks and kill criteria
- Validation plan
- Sources

When creating Markdown, make it scannable and decision-oriented. Prefer tables for competitor comparisons and risk registers.

## Critical Thinking Defaults

Always test these objections:

- "Why not Excel, Copilot, ChatGPT, or existing SaaS?"
- "Is this a feature, product, or services wedge?"
- "Who owns the budget and what existing spend is replaced?"
- "Is the data/security requirement a buying reason or only a nice-to-have?"
- "Can the first use case be solved without LLMs?"
- "Will implementation become bespoke consulting?"
- "What must be repeated enough to justify software?"
- "What is the narrowest painful workflow with urgent demand?"

## File Updates

When the user asks to create or update a business plan file:

- Inspect existing files first.
- Preserve useful existing context unless the user asks for a rewrite.
- Add a dated assumptions/sources section when web research is used.
- Keep claims traceable to sources or mark them as hypotheses.
