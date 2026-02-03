-- SQL Schema for Prophet Portfolio Optimisation
-- Run this in your Supabase SQL Editor to create the required table

-- Create the stock_optimisation_store table
CREATE TABLE IF NOT EXISTS public.stock_optimisation_store (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    as_of_date DATE,
    ticker TEXT NOT NULL,
    predicted_price NUMERIC(10, 2) NOT NULL,
    predicted_return NUMERIC(10, 6) NOT NULL,
    actual_prices_last_month JSONB,
    portfolio_weight NUMERIC(10, 6) NOT NULL,
    
    -- Add constraints
    CONSTRAINT predicted_price_positive CHECK (predicted_price >= 0),
    CONSTRAINT portfolio_weight_range CHECK (portfolio_weight >= 0 AND portfolio_weight <= 1)
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_stock_optimisation_ticker ON public.stock_optimisation_store(ticker);
CREATE INDEX IF NOT EXISTS idx_stock_optimisation_as_of_date ON public.stock_optimisation_store(as_of_date);
CREATE INDEX IF NOT EXISTS idx_stock_optimisation_created_at ON public.stock_optimisation_store(created_at);

-- Enable Row Level Security (RLS) - optional but recommended
ALTER TABLE public.stock_optimisation_store ENABLE ROW LEVEL SECURITY;

-- Create a policy to allow authenticated users to insert and read
-- Adjust this based on your security requirements
CREATE POLICY "Allow public read access" ON public.stock_optimisation_store
    FOR SELECT USING (true);

CREATE POLICY "Allow authenticated insert access" ON public.stock_optimisation_store
    FOR INSERT WITH CHECK (true);

-- Grant permissions
GRANT ALL ON public.stock_optimisation_store TO authenticated;
GRANT SELECT ON public.stock_optimisation_store TO anon;streamlit run src/streamlit_app.pystreamlit run src/streamlit_app.py

-- Add comment to table
COMMENT ON TABLE public.stock_optimisation_store IS 'Stores portfolio optimisation results with predicted prices, returns, and optimal weights for each stock ticker';
