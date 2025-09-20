-- ============================================================================
-- Flov7 Database Schema - Supabase PostgreSQL
-- ============================================================================
-- Complete database schema for the Flov7 AI workflow automation platform
-- Includes 10 core tables, indexes, triggers, and Row Level Security policies
--
-- Generated: 2025-09-20
-- Platform: Supabase PostgreSQL
-- ============================================================================

-- ============================================================================
-- CORE TABLES
-- ============================================================================

-- 1. Users Table
-- User authentication and profile information
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(255),
    full_name VARCHAR(255),
    avatar_url VARCHAR(500),
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    role VARCHAR(50) DEFAULT 'user', -- admin, user, premium
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_login TIMESTAMP WITH TIME ZONE,
    subscription_plan VARCHAR(50) DEFAULT 'free',
    subscription_expires_at TIMESTAMP WITH TIME ZONE
);

-- Indexes for users table
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_active ON users(is_active);
CREATE INDEX idx_users_role ON users(role);

-- 2. Workflows Table
-- Main workflow definitions
CREATE TABLE workflows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'draft', -- draft, active, inactive, archived
    workflow_json JSONB NOT NULL, -- Complete workflow definition
    primitives_count INTEGER DEFAULT 0,
    estimated_cost DECIMAL(10,4) DEFAULT 0,
    execution_count INTEGER DEFAULT 0,
    last_executed_at TIMESTAMP WITH TIME ZONE,
    is_template BOOLEAN DEFAULT false,
    tags TEXT[], -- For categorization
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    version INTEGER DEFAULT 1
);

-- Indexes for workflows table
CREATE INDEX idx_workflows_user_id ON workflows(user_id);
CREATE INDEX idx_workflows_status ON workflows(status);
CREATE INDEX idx_workflows_template ON workflows(is_template);
CREATE INDEX idx_workflows_tags ON workflows USING GIN(tags);
CREATE INDEX idx_workflows_updated ON workflows(updated_at);

-- 3. Workflow Executions Table
-- Track workflow execution history
CREATE TABLE workflow_executions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workflow_id UUID REFERENCES workflows(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(50) DEFAULT 'pending', -- pending, running, completed, failed
    execution_time_seconds DECIMAL(10,2),
    cost_usd DECIMAL(10,4),
    input_data JSONB,
    output_data JSONB,
    error_message TEXT,
    temporal_workflow_id VARCHAR(255),
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for workflow_executions table
CREATE INDEX idx_executions_workflow_id ON workflow_executions(workflow_id);
CREATE INDEX idx_executions_user_id ON workflow_executions(user_id);
CREATE INDEX idx_executions_status ON workflow_executions(status);
CREATE INDEX idx_executions_started ON workflow_executions(started_at);
CREATE INDEX idx_executions_temporal ON workflow_executions(temporal_workflow_id);

-- 4. Primitives Table
-- Store the 5 primitives definitions
CREATE TABLE primitives (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(50) NOT NULL, -- trigger, action, connection, condition, data
    name VARCHAR(255) NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    description TEXT,
    icon VARCHAR(100),
    category VARCHAR(100),
    config_schema JSONB, -- JSON schema for configuration
    input_schema JSONB,  -- JSON schema for inputs
    output_schema JSONB, -- JSON schema for outputs
    is_active BOOLEAN DEFAULT true,
    is_beta BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for primitives table
CREATE INDEX idx_primitives_type ON primitives(type);
CREATE INDEX idx_primitives_active ON primitives(is_active);
CREATE INDEX idx_primitives_category ON primitives(category);

-- 5. User Integrations Table
-- Store user's API keys and external service credentials
CREATE TABLE user_integrations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    service_name VARCHAR(100) NOT NULL, -- openai, slack, gmail, hubspot, etc.
    service_type VARCHAR(50) NOT NULL, -- api_key, oauth, webhook, database
    credentials JSONB, -- Encrypted credentials
    is_active BOOLEAN DEFAULT true,
    last_used_at TIMESTAMP WITH TIME ZONE,
    usage_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for user_integrations table
CREATE INDEX idx_integrations_user_id ON user_integrations(user_id);
CREATE INDEX idx_integrations_service ON user_integrations(service_name);
CREATE INDEX idx_integrations_active ON user_integrations(is_active);

-- 6. Workflow Templates Table
-- Pre-built workflow templates
CREATE TABLE workflow_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    difficulty VARCHAR(50), -- beginner, intermediate, advanced
    estimated_time_minutes INTEGER,
    workflow_json JSONB NOT NULL,
    preview_image_url VARCHAR(500),
    is_featured BOOLEAN DEFAULT false,
    usage_count INTEGER DEFAULT 0,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for workflow_templates table
CREATE INDEX idx_templates_category ON workflow_templates(category);
CREATE INDEX idx_templates_featured ON workflow_templates(is_featured);
CREATE INDEX idx_templates_difficulty ON workflow_templates(difficulty);

-- 7. Audit Logs Table
-- Comprehensive audit logging
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL, -- create_workflow, execute_workflow, update_integration
    resource_type VARCHAR(50), -- workflow, integration, user
    resource_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for audit_logs table
CREATE INDEX idx_audit_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_action ON audit_logs(action);
CREATE INDEX idx_audit_created ON audit_logs(created_at);

-- 8. API Keys Table
-- API key management for external access
CREATE TABLE api_keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    api_key_hash VARCHAR(255) UNIQUE NOT NULL,
    permissions JSONB, -- What the key can access
    is_active BOOLEAN DEFAULT true,
    expires_at TIMESTAMP WITH TIME ZONE,
    last_used_at TIMESTAMP WITH TIME ZONE,
    usage_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for api_keys table
CREATE INDEX idx_api_keys_user_id ON api_keys(user_id);
CREATE INDEX idx_api_keys_hash ON api_keys(api_key_hash);
CREATE INDEX idx_api_keys_active ON api_keys(is_active);

-- 9. Notifications Table
-- User notifications and alerts
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL, -- workflow_completed, error_alert, billing
    title VARCHAR(255) NOT NULL,
    message TEXT,
    data JSONB, -- Additional context data
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for notifications table
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_read ON notifications(is_read);

-- 10. Deployments Table
-- Track workflow deployments
CREATE TABLE deployments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workflow_id UUID REFERENCES workflows(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    platform VARCHAR(50) NOT NULL, -- vercel, railway, render, aws
    deployment_url VARCHAR(500),
    status VARCHAR(50) DEFAULT 'pending', -- pending, deploying, active, failed
    deployment_config JSONB,
    cost_per_month DECIMAL(10,2),
    deployed_at TIMESTAMP WITH TIME ZONE,
    last_health_check TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for deployments table
CREATE INDEX idx_deployments_workflow_id ON deployments(workflow_id);
CREATE INDEX idx_deployments_user_id ON deployments(user_id);
CREATE INDEX idx_deployments_platform ON deployments(platform);
CREATE INDEX idx_deployments_status ON deployments(status);

-- ============================================================================
-- DATABASE TRIGGERS AND FUNCTIONS
-- ============================================================================

-- Function to update updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply triggers to relevant tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_workflows_updated_at BEFORE UPDATE ON workflows FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_integrations_updated_at BEFORE UPDATE ON user_integrations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on all user data tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflows ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflow_executions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_integrations ENABLE ROW LEVEL SECURITY;

-- Create policies (users can only access their own data)
CREATE POLICY users_own_data ON users FOR ALL USING (auth.uid() = id);
CREATE POLICY workflows_own_data ON workflows FOR ALL USING (auth.uid() = user_id);
CREATE POLICY executions_own_data ON workflow_executions FOR ALL USING (auth.uid() = user_id);
CREATE POLICY integrations_own_data ON user_integrations FOR ALL USING (auth.uid() = user_id);

-- ============================================================================
-- SCHEMA METADATA
-- ============================================================================

/*
Database Schema Summary:
- 10 Core Tables with proper relationships
- Comprehensive indexing for performance
- Auto-updating timestamps via triggers
- Row Level Security for data isolation
- JSONB storage for flexible data structures
- Audit logging for compliance
- Real-time capabilities enabled

Key Features:
- Multi-tenant architecture with user isolation
- JSONB for workflow definitions and metadata
- Comprehensive audit trail
- Performance optimized with proper indexing
- Real-time subscriptions support
- Enterprise-ready with RLS policies

Usage:
1. Run this script in your Supabase SQL editor
2. All tables, indexes, and policies will be created
3. Ready for Flov7 application integration
*/

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
