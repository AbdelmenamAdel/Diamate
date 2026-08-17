<div align="center">

# 🍏 DiaMate — Advanced Diabetic & Nutrition Companion
### State-of-the-art Flutter app empowering smarter lifestyles with real-time macro tracking, authentic Egyptian recipe adaptation, and instantaneous multi-provider AI localization.

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Gemini AI](https://img.shields.io/badge/Gemini%20AI-%238E75B2.svg?style=for-the-badge&logo=google&logoColor=white)](https://ai.google.dev/)
[![Groq Fast AI](https://img.shields.io/badge/Groq-Fast_Inference-f39c12?style=for-the-badge)](https://groq.com)
[![DeepSeek AI](https://img.shields.io/badge/DeepSeek-Smart_Models-1abc9c?style=for-the-badge)](https://deepseek.com)
[![Hive Cache](https://img.shields.io/badge/Hive_Cache-Fast_NoSQL-orange?style=for-the-badge)](https://pub.dev/packages/hive)

<img src="assets/images/app_logo.png" alt="DiaMate Icon" width="120" onerror="this.style.display='none'"/>

---

| 🌙 **Dark Aesthetic** | ☀️ **Light Aesthetic** | 🇪🇬 **Adaptive Arabic UI** |
|:---:|:---:|:---:|
| <img src="assets/images/preview_dark.png" width="220" alt="Dark Mode" onerror="this.src='https://placehold.co/220x450/1e1e1e/white?text=Dark+Theme'"/> | <img src="assets/images/preview_light.png" width="220" alt="Light Mode" onerror="this.src='https://placehold.co/220x450/f5f5f5/black?text=Light+Theme'"/> | <img src="assets/images/preview_arabic.png" width="220" alt="Arabic Mode" onerror="this.src='https://placehold.co/220x450/2d9cdb/white?text=Arabic+Locale'"/> |

</div>

---

## 📑 Table of Contents
- [Core Philosophy & Vision](#-core-philosophy--vision)
- [Key Features & Superpowers](#-key-features--superpowers)
- [Enterprise Multi-Provider AI Engine](#-enterprise-multi-provider-ai-engine)
- [Smart Fallback Matrix](#-smart-fallback-matrix)
- [Authentic Diabetic-Friendly Egyptian Meals](#-authentic-diabetic-friendly-egyptian-meals)
- [System Architecture & Lifecycle](#-system-architecture--lifecycle)
- [Getting Started Locally](#-getting-started-locally)
- [Project Architecture Tree](#-project-architecture-tree)

---

## 💡 Core Philosophy & Vision

**DiaMate** is engineered from the ground up to support proactive health monitoring, catering seamlessly to diabetic lifestyles. Unlike generic health platforms, DiaMate infuses live cloud recipe databases with regional Egyptian familiarity and strict low-glycemic standards.

By utilizing a modular, decoupled **Core AI Engine Service**, the app intelligently switches between leading AI endpoints to process abstract payloads (Translations, OCR text extraction, Medical Readings) ensuring uncompromised app responsiveness and layout consistency.

---

## ✨ Key Features & Superpowers

### 🩸 Multi-Modal Glucose Display Detection
* **Direct AI Pixel Analysis:** Integrates high-precision multi-modal vision intelligence capable of parsing photographs of digital meter screens directly to extract accurate primary integer glucose readings.
* **Strict Clinical Rejection Filtering:** Employs advanced negative lookaround regex mapping coupled with explicit unit validation loops to discard background noise, non-reading numerical tokens (e.g., watermarks, IDs), and reliably reject standard non-meter random camera images.

### 🥗 Comprehensive Nutrition Monitoring
* **Intelligent Macros Dashboard:** Visually clean indicators detailing instant protein, carbohydrate, fat, and calorie progress against personalized baseline targets.
* **Camera-Assisted Food Logging:** Launch custom scanning pipelines enabling fluid automated or manual logging workflows directly into localized storage modules.

### 🇪🇬 Authentic Egyptian Focus
* **Live Network Feeds:** Direct REST queries accessing **TheMealDB API** targeting verified local Egyptian recipes modified dynamically to suggest baking, grilling, and using minimal simple carbs.
* **Smart Sentence Formatting:** Automatically parses complex un-spaced paragraphs into clean, numbered instructional steps displayed perfectly across dual language viewports.

---

## 🤖 Enterprise Multi-Provider AI Engine

DiaMate embeds a highly robust, fault-tolerant language mapping and parsing engine (`AiEngineService`) completely decoupled within the core service boundary. 

If remote translation limits intercept primary payload execution, the system gracefully cascades requests down an advanced multi-provider hierarchy before triggering localized runtime dictionaries.

```mermaid
sequenceDiagram
    autonumber
    actor User
    participant Repo as FoodRepoImpl
    participant Engine as Core AiEngineService
    participant Gemini as Gemini 2.5 Flash
    participant Groq as Groq (Llama 3)
    participant DeepSeek as DeepSeek API
    participant Cache as Hive Local Cache

    User->>Repo: Pull to Refresh Meals
    Repo->>Engine: translateMeal(Payload)
    
    critical Failover Strategy
        Engine->>Gemini: Request context translation
        Gemini-->>Engine: [Rate Limit / Exception Hit]
        
        Engine->>Groq: Instant sequential routing (Fallback 1)
        Groq-->>Engine: [Timeout / Throttle Hit]
        
        Engine->>DeepSeek: Final cloud query routing (Fallback 2)
        DeepSeek-->>Engine: Return structured JSON Payload
    end
    
    Engine->>Repo: Return fully populated dual-language model
    Repo->>Cache: Persist reactive record safely
```

---

## 🛡️ Smart Fallback Matrix

DiaMate adopts a robust degradation architecture designed to ensure zero downtime across all user-facing artificial intelligence services:

| Task Domain | Primary Provider | Tier-1 Backup | Ultimate Fallback Strategy |
|:---|:---|:---|:---|
| **Chat & Guidance** | **Gemini 2.5 Flash** | **Groq API** | Static regional behavioral prompt guides |
| **Vision Analysis** | **Gemini Vision** | **OpenRouter API** | Localized camera crop manual logging |
| **Glucose Meter OCR**| **Gemini Vision AI**| **Local ML Kit OCR** | Negative lookaround heuristics & zero-false-positive rejection |
| **Auto-Translation** | **Gemini API** | **DeepSeek / Groq** | Native substring regex matching dictionaries |
| **Nutrition Mapping**| **Edamam API** | **Gemini Core** | Static baseline localized calorie matrices |

---

## 🥘 Authentic Diabetic-Friendly Egyptian Meals

Every loaded meal automatically passes through a highly customized prompt filter dictating that recipes be optimized specifically for healthy lifestyles:
- **Low-Glycemic Replacements:** Instructions explicitly advocate replacing deep-frying with oven-roasting or grilling.
- **Natural Ingredient Tags:** Fallback parameters dynamically assign descriptive Arabic tags (`مكون طبيعي`, `زيت زيتون`, `خبز أسمر`) instantly localizing the interface even offline.

---

## 🏗️ System Architecture & Lifecycle

DiaMate implements the industry-standard **Feature-First Architecture** utilizing clean separation guidelines powered by the **Bloc/Cubit** standard.

```text
       ┌────────────────────────────────────────────────────────┐
       │                   Presentation Layer                   │
       │       (Custom Widgets, Views, ViewModels, Cubits)      │
       └───────────────────────────┬────────────────────────────┘
                                   │  Emits State / Actions
                                   ▼
       ┌────────────────────────────────────────────────────────┐
       │                      Domain Layer                      │
       │           (Abstract Repositories, Contracts)           │
       └───────────────────────────┬────────────────────────────┘
                                   │  Defines API rules
                                   ▼
       ┌────────────────────────────────────────────────────────┐
       │                      Data Layer                        │
       │  (Repo Implementations, Core AiEngineService, Hive)    │
       └────────────────────────────────────────────────────────┘
```

---

## 🚀 Getting Started Locally

### Requirements
- Flutter SDK `3.20+`
- Dart SDK `3.3+`
- Valid API keys assigned inside `lib/constant.dart` configuration structures.

### Quick Setup

```bash
# 1. Clone target code base
git clone https://github.com/AbdelmenamAdel/Diamate.git

# 2. Enter workspace root directory
cd diamate

# 3. Resolve internal library dependencies
flutter pub get

# 4. Compile layout dictionary tokens natively
flutter gen-l10n

# 5. Launch native application builds
flutter run
```

---

## 📁 Project Architecture Tree

```text
lib/
├── core/
│   ├── app/                 # Root initialization blocks & settings Cubits
│   ├── extensions/          # Clean Context-driven navigation shortcuts
│   ├── generated/           # Native asset keys mapping configurations
│   ├── language/            # App localization parsing bindings
│   ├── routes/              # Centralized navigation mapping paths
│   └── services/            # Core Decoupled AiEngineService & Singletons
│
├── features/
│   ├── food/                # Primary macro items, database integrations & Repos
│   ├── main/                # Root navigation layout shells
│   └── profile/             # Modular interactive sheets targeting settings & themes
│
└── main.dart                # Global execution layer injecting active state listeners
```

---

<div align="center">
  <p>Engineered for premium performance, flawless AI failover routing, and complete cultural immersion.</p>
</div>
