## 📁 Flov7 Backend Folder Structure (Microservices)

```
flov7-backend/
├── api-gateway/                    # 🌐 FastAPI Gateway (Port 8000)
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py                 # FastAPI application
│   │   ├── config.py               # Configuration settings
│   │   ├── auth/
│   │   │   ├── __init__.py
│   │   │   ├── jwt_handler.py      # JWT token management
│   │   │   └── api_key_auth.py     # API key authentication
│   │   └── api/
│   │       ├── __init__.py
│   │       ├── v1/
│   │       │   ├── __init__.py
│   │       │   ├── endpoints/       # API endpoint files
│   │       │   └── router.py        # API routing
│   │       └── dependencies.py     # FastAPI dependencies
│   ├── requirements.txt
│   └── Dockerfile
│
├── ai-service/                     # 🤖 OpenAI + 5-primitives (Port 8001)
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py                 # FastAPI application
│   │   ├── config.py               # Configuration settings
│   │   ├── ai/
│   │   │   ├── __init__.py
│   │   │   ├── openai_client.py    # OpenAI API client
│   │   │   └── workflow_generator.py # AI workflow generation
│   │   ├── primitives/
│   │   │   ├── __init__.py
│   │   │   ├── primitives.py       # 5-primitives definitions
│   │   │   └── validation.py       # Primitive validation
│   │   └── api/
│   │       ├── __init__.py
│   │       └── endpoints/          # AI service endpoints
│   ├── requirements.txt
│   └── Dockerfile
│
├── workflow-service/               # ⚙️ Temporal + CrewAI (Port 8002)
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py                 # FastAPI application
│   │   ├── config.py               # Configuration settings
│   │   ├── workflow/
│   │   │   ├── __init__.py
│   │   │   ├── executor.py         # Workflow execution
│   │   │   └── status.py           # Status tracking
│   │   ├── temporal/
│   │   │   ├── __init__.py
│   │   │   ├── client.py           # Temporal client
│   │   │   └── workflows.py        # Temporal workflow definitions
│   │   ├── crewai/
│   │   │   ├── __init__.py
│   │   │   ├── agents.py           # CrewAI agents
│   │   │   └── tasks.py            # CrewAI tasks
│   │   └── api/
│   │       ├── __init__.py
│   │       └── endpoints/          # Workflow service endpoints
│   ├── requirements.txt
│   └── Dockerfile
│
├── shared/                         # 🔄 Common code and utilities
│   ├── models/
│   │   ├── __init__.py
│   │   ├── user.py                 # User data models
│   │   ├── workflow.py             # Workflow data models
│   │   └── primitive.py            # Primitive data models
│   ├── utils/
│   │   ├── __init__.py
│   │   ├── helpers.py              # Helper functions
│   │   └── validators.py           # Data validation
│   ├── config/
│   │   ├── __init__.py
│   │   ├── settings.py             # Global settings
│   │   └── database.py             # Database configuration
│   └── constants/
│       ├── __init__.py
│       ├── primitives.py           # Primitive constants
│       └── status.py               # Status constants
│
├── tests/                          # 🧪 Testing framework
│   ├── unit/                       # Unit tests
│   ├── integration/                # Integration tests
│   ├── e2e/                        # End-to-end tests
│   ├── conftest.py                 # Test configuration
│   └── requirements-test.txt       # Test dependencies
│
├── docker/                         # 🐳 Docker configuration
│   ├── docker-compose.yml          # Main docker-compose
│   ├── docker-compose.dev.yml      # Development setup
│   ├── .env.example                # Environment variables template
│   ├── nginx.conf                  # Nginx reverse proxy
│   ├── api-gateway/                # API Gateway docker config
│   ├── ai-service/                 # AI Service docker config
│   └── workflow-service/           # Workflow Service docker config
│
├── docs/                           # 📚 Documentation
│   ├── api/                        # API documentation
│   ├── architecture/               # Architecture docs
│   ├── deployment/                 # Deployment guides
│   └── README.md                   # Project documentation
│
└── scripts/                        # 🔧 Automation scripts
    ├── setup.sh                    # Project setup script
    ├── deploy.sh                   # Deployment script
    ├── test.sh                     # Testing script
    └── lint.sh                     # Code linting script
```

## 🎯 Key Files Summary

### API Gateway Service
- `main.py` - FastAPI application with routing
- `supabase_auth.py` - Supabase authentication integration
- `api_key_auth.py` - API key authentication (supplemental)
- `router.py` - API endpoint routing
- `dependencies.py` - FastAPI dependency injection

### AI Service
- `openai_client.py` - OpenAI API integration
- `workflow_generator.py` - AI workflow generation logic
- `primitives.py` - 5-primitives system definitions
- `validation.py` - Primitive validation logic

### Workflow Service
- `executor.py` - Workflow execution engine
- `client.py` - Temporal client connection
- `workflows.py` - Temporal workflow definitions
- `agents.py` - CrewAI agent definitions
- `tasks.py` - CrewAI task definitions

### Shared Components
- `user.py` - User data models (Pydantic)
- `workflow.py` - Workflow data models
- `primitive.py` - Primitive data models
- `helpers.py` - Utility functions
- `settings.py` - Global configuration
- `database.py` - Database connection settings

## 🚀 Quick Start Commands

```bash
# 1. Create project structure
mkdir flov7-backend && cd flov7-backend

# 2. Create main directories
mkdir -p api-gateway ai-service workflow-service shared tests docker docs scripts

# 3. Create subdirectories (copy from above structure)
# ... create all the subdirectories as shown above

# 4. Initialize Python modules
find . -type d -exec touch {}/__init__.py \;

# 5. Set up virtual environments
python -m venv venv && source venv/bin/activate

# 6. Install dependencies
pip install fastapi uvicorn pydantic

# 7. Start development
docker-compose -f docker/docker-compose.dev.yml up
```

## 🚀 Flov7 Backend Technologies & Tools List

### 🎯 Core Technologies (Required)

| Technology | Purpose | Version | Service | Status |
|------------|---------|---------|---------|---------|
| **FastAPI** | Web framework for all microservices | 0.104.1 | All services | ✅ Required |
| **Python** | Programming language | 3.11+ | All services | ✅ Required |
| **OpenAI GPT-4** | AI workflow generation | Latest | AI Service | ✅ Required |
| **Temporal** | Workflow orchestration engine | 1.4.0 | Workflow Service | ✅ Required |
| **CrewAI** | Multi-agent AI system | 0.1.0 | Workflow Service | ✅ Required |
| **Supabase** | Database + Auth + Real-time | 2.3.0 | All services | ✅ Required |
| **Redis** | Caching and session management | 5.0.1 | All services | ✅ Required |
| **Docker** | Containerization | Latest | All services | ✅ Required |

### 🔧 Supporting Libraries

| Library | Purpose | Version | Used In |
|---------|---------|---------|---------|
| **Uvicorn** | ASGI server | 0.24.0 | All services |
| **Pydantic** | Data validation | 2.5.0 | All services |
| **Python-JOSE** | JWT handling | 3.3.0 | API Gateway |
| **Passlib** | Password hashing | 1.7.4 | API Gateway |
| **Tiktoken** | Token counting | 0.5.2 | AI Service |
| **Python-dotenv** | Environment variables | 1.0.0 | All services |

### 🛠️ Development Tools

| Tool | Purpose | Used For |
|------|---------|----------|
| **Git** | Version control | Code management |
| **VS Code / Cursor** | IDE | Development |
| **Docker Compose** | Multi-container orchestration | Local development |
| **Postman/Insomnia** | API testing | Testing endpoints |
| **Supabase CLI** | Database management | Database operations |
| **Temporal CLI** | Workflow management | Temporal operations |
| **Ngrok** | Local tunneling | External webhook testing |

### 📊 Monitoring & Logging

| Tool | Purpose | Integration |
|------|---------|-------------|
| **Structured Logging** | Application logging | All services |
| **Health Checks** | Service monitoring | All services |
| **Metrics Collection** | Performance monitoring | All services |
| **Error Tracking** | Exception monitoring | All services |

### 🔐 Security Components

| Component | Purpose | Implementation |
|-----------|---------|----------------|
| **JWT Authentication** | User sessions | API Gateway |
| **API Key Authentication** | External access | API Gateway |
| **Rate Limiting** | Abuse prevention | API Gateway |
| **Input Validation** | Security | All services |
| **Row Level Security** | Database security | Supabase |
| **Environment Variables** | Secret management | All services |

### 📦 External Services

| Service | Purpose | Integration |
|---------|---------|-------------|
| **OpenAI API** | AI workflow generation | AI Service |
| **Supabase** | Database + Auth | All services |
| **Redis** | Caching | All services |
| **Temporal Cloud** | Workflow orchestration | Workflow Service |
| **CrewAI** | Multi-agent processing | Workflow Service |
| **Email Services** | Notifications | Workflow Service |
| **Webhook Services** | External integrations | All services |

### 🧪 Testing Framework

| Testing Type | Tools | Coverage |
|--------------|-------|----------|
| **Unit Tests** | pytest, unittest | Core functions |
| **Integration Tests** | pytest, requests | API endpoints |
| **E2E Tests** | pytest, playwright | Full workflows |
| **Performance Tests** | locust, pytest-benchmark | Load testing |
| **Security Tests** | bandit, safety | Vulnerability scanning |

### 🚀 Deployment Options

| Platform | Best For | Cost | Setup Time |
|----------|----------|------|------------|
| **Docker Compose** | Development | Free | 5 minutes |
| **Vercel** | Simple workflows | Low | 10 minutes |
| **Railway** | Medium complexity | Medium | 15 minutes |
| **Render** | Production apps | Medium | 15 minutes |
| **AWS/GCP** | Enterprise | High | 1 hour |
| **Kubernetes** | Advanced orchestration | High | 2 hours |

### 📚 Documentation

| Document | Purpose | Format |
|----------|---------|--------|
| **API Documentation** | REST API docs | OpenAPI/Swagger |
| **Architecture Docs** | System design | Markdown |
| **Deployment Guides** | Setup instructions | Markdown |
| **Code Comments** | Implementation details | Python docstrings |
| **README** | Project overview | Markdown |

### 🔄 CI/CD Pipeline

| Stage | Tools | Purpose |
|-------|-------|---------|
| **Code Quality** | pre-commit, black, flake8 | Code formatting & linting |
| **Testing** | pytest, coverage | Automated testing |
| **Security** | bandit, safety | Security scanning |
| **Building** | Docker | Container building |
| **Deployment** | Docker Compose | Service deployment |
| **Monitoring** | Health checks | Service verification |

---

## 🎯 Flov7 Technology Stack Summary

### **3 Main Services**
- **API Gateway** (FastAPI + Auth + Rate Limiting)
- **AI Service** (OpenAI GPT-4 + 5-Primitives + Validation)
- **Workflow Service** (Temporal + CrewAI + Python Functions)

### **4 Core Infrastructure**
- **Supabase** (Database + Authentication + Real-time)
- **Redis** (Caching + Session Management)
- **Docker** (Containerization + Deployment)
- **Python 3.11+** (Programming Language)

### **6 Supporting Technologies**
- **FastAPI** (Web Framework)
- **Pydantic** (Data Validation)
- **Uvicorn** (ASGI Server)
- **Python-JOSE** (JWT Handling)
- **Passlib** (Password Hashing)
- **Tiktoken** (Token Counting)

### **Total: 13 Technologies** + Development Tools + Testing Framework + Deployment Options

## 🎯 Flov7 Authentication & Database Setup Summary

### 🔐 **Authentication - Supabase Auth**

**Primary Authentication:**
- ✅ **User Registration & Login** through Supabase Auth UI/API
- ✅ **JWT Token Management** handled by Supabase (no custom implementation needed)
- ✅ **Session Management** with automatic refresh tokens
- ✅ **User Profiles** stored in Supabase with role-based access
- ✅ **Social Logins** (Google, GitHub, etc.) supported out-of-the-box

**Supplemental Authentication:**
- ✅ **API Keys** for external integrations and service-to-service auth
- ✅ **Service Role Keys** for admin operations and database access

### 🗄️ **Database - Supabase PostgreSQL**

**Core Database Features:**
- ✅ **10 Complete Tables** with proper relationships and indexes
- ✅ **Row Level Security (RLS)** for user data isolation
- ✅ **Real-time Subscriptions** for live workflow updates
- ✅ **JSONB Storage** for flexible workflow definitions
- ✅ **Auto-timestamps** with database triggers
- ✅ **Audit Logging** for compliance and debugging
- ✅ **Performance Optimized** with proper indexing

**Database Tables:**
1. **users** - User profiles and authentication
2. **workflows** - Workflow definitions and metadata
3. **workflow_executions** - Execution history and monitoring
4. **primitives** - 5-primitives system definitions
5. **user_integrations** - External API keys and credentials
6. **workflow_templates** - Pre-built workflow templates
7. **audit_logs** - Comprehensive audit trail
8. **api_keys** - API key management
9. **notifications** - User notifications
10. **deployments** - Deployment tracking

### 🔧 **Implementation Benefits**

**Authentication Advantages:**
- 🎯 **No Custom Auth Code** - Use Supabase's battle-tested auth system
- 🔒 **Enterprise Security** - SOC2 compliant authentication
- 🚀 **Quick Setup** - Auth UI and APIs ready in minutes
- 📱 **Multi-Platform** - Web, mobile, and API authentication
- 👥 **Social Logins** - Google, GitHub, Discord, etc.

**Database Advantages:**
- ⚡ **Real-time Features** - Live updates without polling
- 🛡️ **Built-in Security** - RLS and authentication integration
- 📊 **Advanced Queries** - PostgreSQL with JSON support
- 🔍 **Full-text Search** - Built-in search capabilities
- 📈 **Analytics** - Usage tracking and performance metrics

### 🚀 **Development Workflow**

1. **Setup Supabase Project** (5 minutes)
2. **Configure Environment Variables** (2 minutes)
3. **Run Database Migrations** (1 minute)
4. **Implement Supabase Auth Integration** (2 hours)
5. **Test Authentication Flows** (1 hour)

**Total Setup Time: ~4 hours** for complete auth + database system!

### 🔑 **Environment Variables Required**

```bash
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# AI Integration
OPENAI_API_KEY=your-openai-key

# Infrastructure
REDIS_URL=redis://localhost:6379
TEMPORAL_HOST=localhost:7233
```

---

## ✅ **Complete Flov7 Setup Summary**

**What You Get:**
- 🔐 **Production-ready authentication** (Supabase Auth)
- 🗄️ **Enterprise database** (Supabase PostgreSQL)
- 📊 **10 complete tables** with relationships
- 🛡️ **Built-in security** (RLS, audit logs)
- ⚡ **Real-time features** (subscriptions, live updates)
- 🚀 **Quick deployment** (4 hours setup)
- 📱 **Multi-platform support** (web, mobile, API)
- 🔧 **Easy maintenance** (managed infrastructure)

**No Custom Implementation Needed:**
- ❌ No custom JWT handling
- ❌ No custom database setup
- ❌ No custom auth UI
- ❌ No custom session management

**Just Use Supabase!** 🎉

---
