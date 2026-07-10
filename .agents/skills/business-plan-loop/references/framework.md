# Business Plan Loop Framework

## Business Plan Structure

Use this structure when creating or updating a plan.

1. **Executive Summary**
   - One-line thesis
   - Target customer
   - Painful workflow
   - Product wedge
   - Why now

2. **Customer and ICP**
   - Industry
   - Department/persona
   - Company size
   - Trigger event
   - Budget owner
   - Security/compliance requirements
   - Disqualifying conditions

3. **Problem**
   - Current workflow
   - Frequency
   - Cost of failure
   - Current workaround
   - Why existing tools are insufficient

4. **Product**
   - Initial use case
   - User experience
   - System boundaries
   - Must-have features
   - Explicit non-goals
   - Human approval and audit points

5. **Market and Competition**
   - Competitor categories
   - Direct competitors
   - Indirect competitors
   - Internal build/manual workaround
   - "Why not X?" answers
   - Differentiation that survives likely roadmap moves by incumbents

6. **Business Model**
   - Pricing hypothesis
   - Packaging
   - Services vs software split
   - Expansion path
   - Unit economics assumptions

7. **Go-to-Market**
   - First 10 customers
   - Acquisition channel
   - Sales motion
   - Proof required for purchase
   - Pilot design
   - Conversion criteria

8. **Risk Register**
   - Market risk
   - Customer adoption risk
   - Competitive risk
   - Technical risk
   - Security/legal risk
   - Operational risk
   - Mitigation and kill criteria

9. **Validation Plan**
   - Interviews to run
   - Data/files to collect
   - Prototype to build
   - Pricing test
   - Success thresholds
   - Decision dates

10. **Sources and Assumptions**
    - Sources with links
    - Evidence-backed claims
    - Inferences
    - Unknowns

## Critique Checklist

Use these questions to pressure-test the idea.

### Customer

- Who has the pain today?
- Is the pain frequent, expensive, risky, or politically visible?
- Who feels the pain and who pays?
- What happens if the customer does nothing?
- Does the buyer already have budget for this category?

### Workflow

- What exact workflow is repeated?
- How often does it happen?
- Which step is most painful?
- Which step has the highest failure cost?
- What part must be deterministic rather than AI-generated?

### Competition

- What would the customer use instead?
- Why is Excel not enough?
- Why is Copilot/ChatGPT not enough?
- Why is an existing SaaS not enough?
- Why would an incumbent not add this feature?

### Security and Compliance

- Is security a blocker, a differentiator, or just table stakes?
- What data cannot leave the environment?
- Does the buyer require on-prem, private cloud, tenant isolation, or audit logs?
- What certifications or policies are required for purchase?

### Business Model

- Is the product replacing labor, software, outsourcing, or risk?
- Is the buyer willing to pay before full automation?
- Can services fund product learning without trapping the company in bespoke work?
- What metric should pricing scale with?

### Technical

- Can the first version work without LLMs?
- What should LLMs do, and what should deterministic code do?
- How are outputs tested?
- How are generated rules reviewed and approved?
- How are errors surfaced and corrected?

## Research Plan Template

Use this before web research.

```markdown
## Research Questions

1. What existing tools already solve this?
2. How do incumbents describe their capabilities and pricing?
3. What security/compliance constraints shape buying?
4. What customer evidence shows this workflow is painful?
5. What wedge is underserved?

## Source Priorities

- Official product/pricing/docs pages
- Customer case studies
- Security/compliance documentation
- Industry reports and government/regulatory sources
- Credible practitioner posts only when primary sources are unavailable
```

## Objection Answer Template

Use this for "Why not X?" sections.

```markdown
## Why Not X?

Short answer:

| Dimension | X | Proposed product |
|---|---|---|
| Primary user | | |
| Workflow type | | |
| Reproducibility | | |
| Auditability | | |
| Security model | | |
| Integration | | |

Best answer:

Residual risk:
```

## Validation Interview Template

Use concise questions. Do not pitch first.

1. Walk me through the last time this workflow happened.
2. What file/data did you start from?
3. What did you check or transform manually?
4. How long did it take?
5. What mistakes happen?
6. Who reviews the result?
7. What happens if it is wrong?
8. What tools have you tried?
9. Could you use Copilot/ChatGPT for this? Why or why not?
10. What would this need to do for you to pay for it?
