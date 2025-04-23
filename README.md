# Ask AI

**Ask AI** is a web-based application that uses real, human expert–answered questions from the **Ask Extension** knowledgebase to benchmark the performance of AI-generated responses against those provided by Cooperative Extension professionals.

---

## 🧠 What It Does

At its core, the app allows users to:

- 📌 View a real question asked through Ask Extension  
- 🧪 Compare multiple anonymized responses — one from a human expert, others from AI models (e.g., GPT-4, Claude, Gemini)  
- 🗳️ Vote on which response they believe is the most appropriate  
- 🕵️ Optionally, guess which answer came from a human expert  

Each vote contributes to an evolving leaderboard that ranks AI models and human experts based on perceived quality, helping to identify how well AI performs in the domain of public agricultural and Extension knowledge.

---

## 🔑 Key Features

✅ **Expert-vetted questions** imported from Ask Extension  
✅ **Clean, curated answers** with randomized display order to avoid bias  
✅ **User voting** and *“guess the human”* gameplay  
✅ **Public leaderboard** of performance by source (AI model or human)  
✅ **Admin interface** for reviewing and approving question–answer pairs before public display  
✅ **Option for user submissions** for future comparison and evaluation  

---

## 🎯 Design Goals

- Focus on **data quality** by curating one clear answer per question  
- Maintain **transparency and neutrality** by anonymizing all sources in the public interface  
- Encourage **public engagement** with Extension knowledge while exploring the role of generative AI in agricultural education and support

## ⚙️ Setup Instructions

To set up the application locally for development:

1. Install dependencies:

   ```bash
   bundle install
   yarn install
	 rails db:create
	 rails db:migrate
   -run rails "import:questions[1000]"  to import Ask Extension questions (contact Mark Locklear for full question set); pass the number of questions you would like to import
   -run db:seed to create sources and admin user
   -run rails dev:reset to reset your database
   -run bundle exec sidekiq to start sidekiq(used during ai answer generation)
