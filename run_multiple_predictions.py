"""Run portfolio optimization for multiple historical dates to populate dashboard trends."""
from dotenv import load_dotenv
load_dotenv()

from src.main import run_optimisation, save_results_to_supabase
from datetime import datetime, timedelta

# Run predictions for multiple dates to build historical data
dates = [
    "2023-11-30",  # November end
    "2023-12-15",  # Mid December
    "2023-12-31",  # Year end (already have this)
]

for end_date in dates:
    print(f"\n{'='*60}")
    print(f"Running optimization for date: {end_date}")
    print('='*60)
    
    result = run_optimisation(
        tickers=['AMD', 'MSFT', 'AAPL', 'TSLA', 'AMZN', 'NVDA', 'META', 'GOOGL', 'TSM', 'JPM', 'NFLX', 'PLTR'],
        start_date="2023-01-01",
        end_date=end_date
    )
    
    if result:
        try:
            save_results_to_supabase(result)
            print(f"✅ Successfully saved predictions for {end_date}")
        except Exception as e:
            print(f"❌ Failed to save for {end_date}: {e}")
    else:
        print(f"❌ No results for {end_date}")

print(f"\n{'='*60}")
print("✅ All predictions completed! Refresh your Streamlit dashboard.")
print('='*60)
