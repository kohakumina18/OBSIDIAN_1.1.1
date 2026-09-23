Below is a structured summary and explanation of the **key concepts** and **key methods** from the video transcript **“How to Ask Better Questions – Business Analysis Live!”**.

# 1. Core message

The main idea is:

> **Business Analysis is not mainly about having answers. It is about asking better questions so you can understand the real problem before jumping to a solution.**

The speakers emphasize that a Business Analyst must avoid simply recording what stakeholders ask for. Many stakeholders come with a “solution” already in mind, but the BA’s job is to uncover:

- ==What problem are they actually trying to solve?==
    
- ==Why does that problem matter?==
    
- ==Who is affected?==
    
- ==What options exist?==
    
- ==Which solution best fits the business need?==
    

# 2. Key concept: Open-ended questions

A major concept is the difference between **closed-ended** and **open-ended** questions.

A closed-ended question usually leads to a short answer like “yes” or “no”.

Example:

> “Did you have a good day?”

An open-ended question forces the person to explain, think, and share context.

Example:

> “Tell me about your day.”

In Business Analysis, open-ended questions are more powerful because they help reveal hidden details, assumptions, pain points, and business context.

Good BA questions include:

> “Tell me more about that.”

> “What problem are you trying to solve?”

> “What happens next?”

> “What else?”

# 3. Key concept: Listen to understand, not to respond

The speakers make an important distinction:

> **Listening to respond** means you are already thinking about your next question or your own solution while the stakeholder is talking.

> **Listening to understand** means you pause, absorb the information, take notes, and only then continue.

This is critical because many analysts enter “solution mode” too early. They hear a problem and immediately start designing a fix. That can cause them to miss the real business need.

A good BA should stay in **information collection mode** first.

# 4. Key concept: Create a safe space

Asking good questions is not only about the wording. The environment matters.

The stakeholder must feel safe enough to answer honestly. That means the BA should be:

- Non-judgmental
    
- Patient
    
- Respectful
    
- Comfortable with silence
    
- Willing to listen fully
    
- Careful not to make the stakeholder feel stupid or attacked
    

This is especially important when using “why” questions, because “Why did you do that?” can sound accusatory if asked badly.

Instead of repeatedly asking “why?”, the BA can soften the question:

> “Can you help me understand the reason behind that?”

> “What led to that decision?”

> “Tell me more about how that works.”

# 5. Key method: The Five Whys

The **Five Whys** is a root-cause analysis technique.

The basic idea is simple:

> Ask “why” repeatedly until you reach the deeper cause of a problem.

Example:

1. Why is the report late?  
    Because the data is not ready.
    
2. Why is the data not ready?  
    Because the source system export is delayed.
    
3. Why is the export delayed?  
    Because someone manually prepares it.
    
4. Why is it manual?  
    Because there is no automated integration.
    
5. Why is there no integration?  
    Because the process was never prioritized by management.
    

The real issue is not just “the report is late.”  
The real issue may be lack of automation, unclear ownership, or low prioritization.

Important note from the video: you do **not** always need exactly five whys. Sometimes three are enough. The point is not the number. The point is to **dig deeper**.

# 6. Key method: “Tell me more”

This is one of the most useful phrases mentioned in the video.

When a stakeholder gives a vague, short, or surface-level answer, the BA can say:

> “Tell me more.”

This keeps the conversation open without sounding aggressive.

Example:

Stakeholder says:

> “The current process is too slow.”

BA asks:

> “Tell me more about where it slows down.”

This can reveal whether the issue is caused by system performance, approval delays, missing data, unclear responsibility, or manual work.

# 7. Key method: “What else?”

Another powerful question is:

> “What else?”

This is especially useful in workshops or group discussions.

When people stop talking, many facilitators assume the discussion is finished. But often, people are still thinking. Asking “What else?” and staying silent can generate more ideas.

This method helps:

- Bring quieter people into the discussion
    
- Surface additional requirements
    
- Reveal edge cases
    
- Encourage broader participation
    
- Avoid stopping too early
    

# 8. Key concept: Stakeholders often bring solutions, not problems

The video explains a common BA challenge:

Stakeholders often say:

> “I need this feature.”

> “I need this report.”

> “I need this system.”

But what they are really saying is:

> “I have a problem, and I think this is the solution.”

The BA should not reject their idea immediately. Instead, the BA should guide the conversation back to the problem.

Useful question:

> “What problem are we trying to solve?”

Example:

Stakeholder says:

> “I need an email template.”

BA asks:

> “What problem are you trying to solve with the email template?”

Maybe the real problem is poor communication, missing approval reminders, unclear ownership, or lack of workflow tracking. An email template may not be the best solution.

# 9. Key method: Fishbone diagram

The **Fishbone Diagram**, also called an **Ishikawa Diagram**, is used for root-cause analysis.

It helps a group visually organize possible causes of a problem.

The “head” of the fish is the problem.  
The “bones” are categories of possible causes.

For example, if the problem is:

> “Invoice processing takes too long.”

Possible fishbone categories could be:

|Category|Possible causes|
|---|---|
|People|Staff not trained, unclear responsibilities|
|Process|Too many approval steps, no standard workflow|
|System|Slow ERP, missing integration|
|Data|Wrong PO number, missing supplier info|
|Policy|Complex approval rules|
|External|Supplier sends incomplete invoice|

The video explains that Fishbone is more useful in **facilitated group sessions** than in one-on-one interviews.

# 10. Five Whys vs Fishbone Diagram

The video compares these two methods indirectly.

|Method|Best used for|Style|
|---|---|---|
|Five Whys|Interviewing, digging deeper into one issue|Linear questioning|
|Fishbone Diagram|Group brainstorming, root-cause mapping|Visual categorization|

In simple terms:

> **Five Whys helps you go deep.**  
> **Fishbone helps you go wide.**

Five Whys is good when you want to trace one chain of cause and effect.

Fishbone is good when you want to explore many possible causes from different angles.

# 11. Key method: Context diagram

A **Context Diagram** shows the big picture of a system, process, or problem area.

It helps answer:

- What system/process are we analyzing?
    
- Who interacts with it?
    
- What data flows in and out?
    
- What external systems are connected?
    
- What is inside scope and outside scope?
    

The speakers say a context diagram is useful because it prevents people from getting lost in details too early.

In BA work, this is very useful before writing detailed requirements.

# 12. Key method: Swimlane diagram

A **Swimlane Diagram** maps a process by role or department.

Each “lane” represents a person, team, department, or system.

Example lanes:

- User
    
- Purchasing Department
    
- Finance Department
    
- ERP System
    
- Supplier
    

Each step is placed in the lane of the person or system responsible for that action.

This is powerful because it shows:

- Who does what
    
- Where handoffs happen
    
- Where delays occur
    
- Where responsibility is unclear
    
- Where automation may help
    

For your work, this is especially relevant to workflows like WFX purchasing, GRN creation, supplier invoice processing, Directus imports, and n8n automation.

# 13. Key concept: Be prepared, but do not over-script

The speakers advise BAs to prepare questions before interviews or workshops.

But they also warn not to turn the session into a rigid script.

A good BA should prepare key topics, then follow the information.

Meaning:

> Prepare your direction, but let the stakeholder’s answers guide the exploration.

This matters because the most valuable information often appears unexpectedly.

# 14. Key concept: Business Analysis is a relationship business

The video repeatedly emphasizes that BA work is human work.

Even if the project is technical, the BA must work with people who may be:

- Defensive
    
- Busy
    
- Senior
    
- Uncooperative
    
- Overconfident
    
- Afraid of change
    
- Attached to their own solution
    

So a BA needs relationship skills, not only modeling or documentation skills.

Good BA behavior includes:

- Building trust
    
- Reading the room
    
- Understanding stakeholder mood
    
- Rescheduling when the timing is bad
    
- Using empathy
    
- Finding allies when a stakeholder blocks progress
    

# 15. Key method: Decision criteria and scoring

When a stakeholder insists their solution is the best, the speakers suggest using a more objective approach.

The BA can define evaluation criteria, assign weights, and score each solution.

Example:

|Criteria|Weight|Solution A|Solution B|
|---|--:|--:|--:|
|Cost|30%|8|6|
|Implementation speed|25%|7|9|
|User experience|25%|6|8|
|Scalability|20%|9|7|

This helps move the discussion away from personal opinion and toward business decision-making.

This is especially useful for software selection, vendor comparison, or choosing between automation approaches.

# 16. Key concept: In Agile, questions still matter

One question in the video asks whether short Agile delivery timelines change the way BAs ask questions.

The answer: the core techniques do not change.

But in Agile, the BA must be more focused.

The BA should understand:

- The big picture
    
- The specific user story or small scope being delivered
    
- The customer pain point
    
- The acceptance criteria
    
- The impact on the wider process
    

Agile does not remove analysis. It compresses it. So the BA must ask sharper questions faster.

# 17. Practical BA question toolkit

Here is the most useful question toolkit from the video:

|Situation|Useful question|
|---|---|
|Stakeholder gives short answer|“Tell me more.”|
|Stakeholder stops after a few ideas|“What else?”|
|Stakeholder gives a solution|“What problem are we trying to solve?”|
|Need root cause|“Why does that happen?”|
|Need process detail|“What happens next?”|
|Need ownership clarity|“Who is responsible for that step?”|
|Need business value|“Why is that important to the business?”|
|Need priority|“Which of these matters most?”|
|Need pain point|“Where does this process break down?”|
|Need decision logic|“How do you decide what to do next?”|

# 18. Most important takeaway

The strongest takeaway is:

> A good Business Analyst does not just ask questions to collect requirements.  
> A good Business Analyst asks questions to discover the real business problem, guide stakeholders toward clarity, and support better decisions.

The BA’s value comes from slowing down the rush to solution, creating understanding, and helping the business choose the right path.

## 🔗 Related Concepts
- [[Problem Definition]]
- [[Stakeholder Management]]
- [[Communication]]
- [[Root Cause Analysis]]
- [[Process Improvement]]

## 🛠 Methods
- [[Five Whys]]
- [[Fishbone Diagram]]
- [[Context Diagram]]
- [[Swimlane Diagram]]
- [[Decision Scoring Matrix]]

## 📂 Applications
- [[SmartFlow Automation]]
- [[Ex-Im Automation]]
- [[WFX Purchasing Flow]]

## 🧠 Insights
- [[Solution Bias]]
- [[Requirement vs Problem]]
- [[Stakeholder Alignment]]