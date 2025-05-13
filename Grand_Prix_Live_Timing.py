#!/usr/bin/env python3

import json
import random
import time
import math
import threading
from flask import Flask, jsonify
from datetime import datetime, timedelta

app = Flask(__name__)

# F1 2025 driver data (updated to match the provided list)
DRIVERS = [
    {"driverNumber": 81, "fullName": "Oscar Piastri", "teamName": "McLaren", "teamColour": "#FF8000", "code": "PIA"},
    {"driverNumber": 4, "fullName": "Lando Norris", "teamName": "McLaren", "teamColour": "#FF8000", "code": "NOR"},
    {"driverNumber": 1, "fullName": "Max Verstappen", "teamName": "Red Bull Racing", "teamColour": "#3671C6", "code": "VER"},
    {"driverNumber": 63, "fullName": "George Russell", "teamName": "Mercedes", "teamColour": "#27F4D2", "code": "RUS"},
    {"driverNumber": 16, "fullName": "Charles Leclerc", "teamName": "Ferrari", "teamColour": "#E8002D", "code": "LEC"},
    {"driverNumber": 44, "fullName": "Lewis Hamilton", "teamName": "Ferrari", "teamColour": "#E8002D", "code": "HAM"},
    {"driverNumber": 12, "fullName": "Kimi Antonelli", "teamName": "Mercedes", "teamColour": "#27F4D2", "code": "ANT"},
    {"driverNumber": 23, "fullName": "Alex Albon", "teamName": "Williams", "teamColour": "#64C4FF", "code": "ALB"},
    {"driverNumber": 31, "fullName": "Esteban Ocon", "teamName": "Alpine", "teamColour": "#FF87BC", "code": "OCO"},
    {"driverNumber": 18, "fullName": "Lance Stroll", "teamName": "Aston Martin", "teamColour": "#006F62", "code": "STR"},
    {"driverNumber": 22, "fullName": "Yuki Tsunoda", "teamName": "RB F1 Team", "teamColour": "#6692FF", "code": "TSU"},
    {"driverNumber": 10, "fullName": "Pierre Gasly", "teamName": "Alpine", "teamColour": "#FF87BC", "code": "GAS"},
    {"driverNumber": 55, "fullName": "Carlos Sainz", "teamName": "Audi", "teamColour": "#C92D4B", "code": "SAI"},
    {"driverNumber": 27, "fullName": "Nico Hulkenberg", "teamName": "Sauber", "teamColour": "#52E252", "code": "HUL"},
    {"driverNumber": 87, "fullName": "Oliver Bearman", "teamName": "Haas F1 Team", "teamColour": "#B6BABD", "code": "BEA"},
    {"driverNumber": 6, "fullName": "Isaac Hadjar", "teamName": "RB F1 Team", "teamColour": "#6692FF", "code": "HAD"},
    {"driverNumber": 14, "fullName": "Fernando Alonso", "teamName": "Aston Martin", "teamColour": "#006F62", "code": "ALO"},
    {"driverNumber": 30, "fullName": "Liam Lawson", "teamName": "Haas F1 Team", "teamColour": "#B6BABD", "code": "LAW"},
    {"driverNumber": 7, "fullName": "Jack Doohan", "teamName": "Alpine", "teamColour": "#FF87BC", "code": "DOO"},
    {"driverNumber": 5, "fullName": "Gabriel Bortoleto", "teamName": "Sauber", "teamColour": "#52E252", "code": "BOR"}
]

# Realistic lap times for Miami circuit - 2025
SESSION_BASE_TIMES = {
    "FP1": 87.8,  # 1:27.800
    "FP2": 87.2,  # 1:27.200
    "FP3": 86.8,  # 1:26.800
    "Qualifying": 85.5,  # 1:25.500 - Miami is typically around this time
    "Race": 87.0   # 1:27.000
}

# Tyre compounds and their performance characteristics
TYRES = {
    "soft": {"color": "red", "performance": 0.0, "degradation": 0.05},
    "medium": {"color": "yellow", "performance": 0.5, "degradation": 0.03},
    "hard": {"color": "white", "performance": 1.0, "degradation": 0.02},
    "intermediate": {"color": "green", "performance": 5.0, "degradation": 0.04},
    "wet": {"color": "blue", "performance": 8.0, "degradation": 0.03}
}

# Qualifying session structure
# Durations are in seconds. Total Q1+Q2+Q3 = 100+90+70 = 260 seconds (4 minutes 20 seconds)
QUALIFYING_STRUCTURE = {
    "Q1": {"duration": 100, "eliminated": 5},
    "Q2": {"duration": 90, "eliminated": 5},
    "Q3": {"duration": 70, "eliminated": 0}
}

# Current session data - Miami GP Qualifying 2025
current_session = {
    "name": "Qualifying",
    "phase": "Q1",  # Current qualifying phase (Q1, Q2, Q3)
    "circuit": "Miami International Autodrome",
    "country": "United States",
    "is_active": True,
    "lap_times": {},
    "current_tyres": {},
    "best_times": {},
    "lap_count": {},
    "eliminated_drivers": [],
    "session_start": datetime.now().isoformat(),
    "phase_start": datetime.now().isoformat(),
    "time_remaining": QUALIFYING_STRUCTURE["Q1"]["duration"],
    "weather": "Clear",
    "track_temp": 45,  # Celsius
    "air_temp": 30     # Celsius
}

# Real Miami qualifying times from 2022-2023 (adjusted for 2025 performance)
MIAMI_QUALIFYING_TARGETS = {
    # Driver number: expected Q3 time
    4: 84.532,   # Lando Norris (McLaren) - pole
    1: 84.716,   # Max Verstappen (Red Bull)
    16: 84.848,  # Charles Leclerc (Ferrari)
    44: 84.969,  # Lewis Hamilton (Ferrari)
    81: 85.046,  # Oscar Piastri (McLaren)
    63: 85.201,  # George Russell (Mercedes)
    12: 85.332,  # Kimi Antonelli (Mercedes)
    55: 85.431,  # Carlos Sainz (Audi)
    14: 85.437,  # Fernando Alonso (Aston Martin)
    22: 85.671,  # Yuki Tsunoda (RB)
    
    # Q2 eliminations (11-15)
    23: 85.889,  # Alex Albon (Williams)
    6: 85.901,   # Isaac Hadjar (RB)
    18: 85.975,  # Lance Stroll (Aston Martin)
    87: 86.170,  # Oliver Bearman (Haas)
    10: 86.282,  # Pierre Gasly (Alpine)
    
    # Q1 eliminations (16-20)
    30: 86.456,  # Liam Lawson (Haas)
    31: 86.634,  # Esteban Ocon (Alpine)
    7: 86.815,   # Jack Doohan (Alpine)
    27: 86.921,  # Nico Hulkenberg (Sauber)
    5: 87.103,   # Gabriel Bortoleto (Sauber)
}

# Simulation thread
simulation_thread = None
simulation_running = False

# Initialize driver lap times and tyres
for driver in DRIVERS:
    driver_num = driver["driverNumber"]
    current_session["lap_times"][driver_num] = []
    current_session["best_times"][driver_num] = None
    current_session["lap_count"][driver_num] = 0
    current_session["current_tyres"][driver_num] = "soft"

def generate_lap_time(driver_num, session_type, phase="Q1", is_final_push=False):
    """Generate a realistic lap time for a driver based on various factors"""
    target_time = MIAMI_QUALIFYING_TARGETS.get(driver_num, None)
    base_time = SESSION_BASE_TIMES[session_type]
    
    driver_index = next((i for i, d in enumerate(DRIVERS) if d["driverNumber"] == driver_num), 0)
    driver_skill = max(0.75, 1 - (driver_index * 0.015))
    
    team_name = next((d["teamName"] for d in DRIVERS if d["driverNumber"] == driver_num), "")
    team_performance = {
        "Red Bull Racing": 0.985, "Ferrari": 0.987, "Mercedes": 0.990,
        "McLaren": 0.982, "Aston Martin": 1.000, "Alpine": 1.015,
        "Williams": 1.010, "Sauber": 1.020, "RB F1 Team": 1.005,
        "Haas F1 Team": 1.018, "Audi": 1.010
    }.get(team_name, 1.0)
    
    tyre = current_session["current_tyres"][driver_num]
    tyre_factor = TYRES[tyre]["performance"]
    
    lap_count = current_session["lap_count"][driver_num]
    tyre_deg = TYRES[tyre]["degradation"] * lap_count if lap_count > 0 else 0
    
    phase_improvement = {"Q1": 0.0, "Q2": -0.3, "Q3": -0.6}.get(phase, 0.0)
    final_push_factor = -0.25 if is_final_push else 0.0 # Renamed variable for clarity
    variation = random.uniform(-0.2, 0.4)
    
    if target_time:
        current_phase_factor = {"Q1": 1.03, "Q2": 1.015, "Q3": 1.0}.get(phase, 1.0)
        if phase == "Q3" and is_final_push:
            lap_time = target_time + random.uniform(-0.05, 0.15)
        else:
            lap_time = target_time * current_phase_factor + phase_improvement + variation
    else:
        lap_time = base_time * driver_skill * team_performance + tyre_factor + tyre_deg + phase_improvement + final_push_factor + variation
    
    if random.random() < 0.08:  # 8% chance of a mistake
        lap_time += random.uniform(0.3, 1.5)
    
    return round(lap_time, 3)

def update_session_lap_times():
    """Simulate lap times for active drivers"""
    active_drivers = [d["driverNumber"] for d in DRIVERS if d["driverNumber"] not in current_session["eliminated_drivers"]]
    if not active_drivers: return

    drivers_to_update = random.sample(
        active_drivers, 
        k=min(len(active_drivers), random.randint(3, max(3, len(active_drivers) // 2)))
    )
    
    current_phase = current_session["phase"]
    time_remaining = current_session["time_remaining"]
    is_final_push = time_remaining < 20
    
    for driver_num in drivers_to_update:
        new_lap = generate_lap_time(
            driver_num, current_session["name"], 
            phase=current_phase, is_final_push=is_final_push
        )
        lap_number = current_session["lap_count"][driver_num] + 1
        
        sector1 = round(new_lap * 0.3 + random.uniform(-0.1, 0.1), 3)
        sector2 = round(new_lap * 0.42 + random.uniform(-0.15, 0.15), 3)
        sector3 = round(new_lap - sector1 - sector2, 3)
        
        lap_entry = {
            "driverNumber": driver_num, "lapNumber": lap_number, "lapTime": new_lap,
            "sector1Time": sector1, "sector2Time": sector2, "sector3Time": sector3,
            "timestamp": datetime.now().isoformat()
        }
        
        current_session["lap_times"][driver_num].append(lap_entry)
        current_session["lap_count"][driver_num] = lap_number
        
        if (current_session["best_times"][driver_num] is None or 
            new_lap < current_session["best_times"][driver_num]):
            current_session["best_times"][driver_num] = new_lap
            
        if random.random() < 0.05:
            if current_phase == "Q1" or current_phase == "Q2":
                current_session["current_tyres"][driver_num] = random.choices(
                    ["soft", "medium"], weights=[0.9, 0.1]
                )[0]
            else:
                current_session["current_tyres"][driver_num] = "soft"

def determine_eliminated_drivers():
    """Determine which drivers are eliminated at the end of a qualifying phase"""
    drivers_with_times = []
    for driver_num, best_time in current_session["best_times"].items():
        if best_time and driver_num not in current_session["eliminated_drivers"]:
            drivers_with_times.append((driver_num, best_time))
    
    drivers_with_times.sort(key=lambda x: x[1])
    
    phase = current_session["phase"]
    num_to_eliminate = QUALIFYING_STRUCTURE[phase]["eliminated"]
    
    if len(drivers_with_times) > num_to_eliminate and num_to_eliminate > 0: # check num_to_eliminate > 0
        return [driver_num for driver_num, _ in drivers_with_times[-num_to_eliminate:]]
    return []

def advance_qualifying_phase():
    """Advance to the next qualifying phase"""
    current_phase = current_session["phase"]
    
    eliminated = determine_eliminated_drivers()
    current_session["eliminated_drivers"].extend(eliminated)
    
    if current_phase == "Q1":
        current_session["phase"] = "Q2"
        current_session["time_remaining"] = QUALIFYING_STRUCTURE["Q2"]["duration"]
    elif current_phase == "Q2":
        current_session["phase"] = "Q3"
        current_session["time_remaining"] = QUALIFYING_STRUCTURE["Q3"]["duration"]
    else: # End of Q3
        current_session["is_active"] = False
        current_session["time_remaining"] = 0
        return False # No more phases
            
    current_session["phase_start"] = datetime.now().isoformat()
    return True # Advanced to next phase

def qualifying_simulation_thread():
    """Thread to run the qualifying simulation"""
    global simulation_running, current_session # Ensure we modify global current_session
    
    update_interval = 2
    fast_forward_factor = 1
    
    # This print is part of the simulation thread's own lifecycle
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] Starting {current_session['name']} simulation for {current_session['circuit']}...")
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] Phase: {current_session['phase']}, Time remaining: {current_session['time_remaining']}s")
    
    while simulation_running and current_session["is_active"]:
        update_session_lap_times()
        
        time_decrease = update_interval * fast_forward_factor
        current_session["time_remaining"] = max(0, current_session["time_remaining"] - time_decrease)
        
        if current_session["time_remaining"] <= 0:
            print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] End of {current_session['phase']}")
            
            if not advance_qualifying_phase(): # This sets is_active=False if qualifying ends
                break # Exit loop if qualifying is over
            
            print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] Starting {current_session['phase']}, Time remaining: {current_session['time_remaining']}s")
            if current_session["eliminated_drivers"]: # Print only if there are new eliminations for this phase transition
                 # To avoid re-printing all eliminations, track last printed eliminations or be more specific
                newly_eliminated_this_phase = QUALIFYING_STRUCTURE[current_session["phase"] if current_session["phase"] != "Q1" else "Q1"]["eliminated"] # A bit complex, simplify if needed
                # This logic for printing eliminations could be refined if it's too noisy or not showing the right drivers.
                # For now, it prints all eliminated so far.
                print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] Eliminated drivers so far: {current_session['eliminated_drivers']}")
        
        time.sleep(update_interval)
    
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] Qualifying simulation ended.")
    current_session["is_active"] = False # Ensure it's marked inactive

def reset_session_state():
    """Reset the session state for a new qualifying session"""
    global current_session # Ensure we are modifying the global current_session
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] Resetting session state for new qualifying.")
    current_session["name"] = "Qualifying" # Ensure it's set to qualifying
    current_session["phase"] = "Q1"
    current_session["time_remaining"] = QUALIFYING_STRUCTURE["Q1"]["duration"]
    current_session["eliminated_drivers"] = []
    current_session["is_active"] = True # Crucial: set to active for the new session
    current_session["session_start"] = datetime.now().isoformat()
    current_session["phase_start"] = datetime.now().isoformat()
    
    for driver in DRIVERS:
        driver_num = driver["driverNumber"]
        current_session["lap_times"][driver_num] = []
        current_session["best_times"][driver_num] = None
        current_session["lap_count"][driver_num] = 0
        current_session["current_tyres"][driver_num] = "soft"

def start_qualifying_simulation():
    """Start the qualifying simulation in a separate thread"""
    global simulation_thread, simulation_running
    
    if simulation_thread and simulation_thread.is_alive():
        print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] Attempting to stop previous simulation thread...")
        simulation_running = False
        simulation_thread.join(timeout=5) # Wait for up to 5s
        if simulation_thread.is_alive():
            print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] Warning: Previous simulation thread did not terminate cleanly.")


    reset_session_state() # Reset state BEFORE starting new thread
    
    simulation_running = True # Set to True for the new simulation
    current_session["is_active"] = True # Ensure session is active
    
    simulation_thread = threading.Thread(target=qualifying_simulation_thread)
    simulation_thread.daemon = True # So it exits if main thread exits
    simulation_thread.start()
    
    return {"status": "started", "session": current_session["name"], "phase": current_session["phase"]}

@app.route('/api/sessions/current', methods=['GET'])
def get_current_session():
    return jsonify({
        "name": current_session["name"], "phase": current_session["phase"],
        "circuit": current_session["circuit"], "country": current_session["country"],
        "is_active": current_session["is_active"], "time_remaining": current_session["time_remaining"],
        "session_start": current_session["session_start"],
        "eliminated_drivers": current_session["eliminated_drivers"]
    })

@app.route('/api/drivers', methods=['GET'])
def get_drivers():
    drivers_with_headshots = []
    for driver in DRIVERS:
        d_copy = driver.copy() # Avoid modifying the original DRIVERS list
        d_copy["headshotUrl"] = f"https://via.placeholder.com/150?text={driver['code']}"
        drivers_with_headshots.append(d_copy)
    return jsonify(drivers_with_headshots)


@app.route('/api/laptimes/current', methods=['GET'])
def get_current_laptimes():
    result = []
    for driver_num, laps in current_session["lap_times"].items():
        if laps:
            result.append(laps[-1])
    result.sort(key=lambda x: x["lapTime"])
    return jsonify(result)

@app.route('/api/tyres/current', methods=['GET'])
def get_current_tyres():
    result = []
    for driver_num, compound in current_session["current_tyres"].items():
        result.append({
            "driverNumber": driver_num, "compound": compound, "stint": 1
        })
    return jsonify(result)

@app.route('/api/timing/complete', methods=['GET'])
def get_complete_timing():
    best_times_list = [] # Renamed to avoid conflict
    for driver_num, best_time in current_session["best_times"].items():
        if best_time:
            driver_info = next((d for d in DRIVERS if d["driverNumber"] == driver_num), None)
            if driver_info:
                best_times_list.append({
                    "driverNumber": driver_num, "driverCode": driver_info["code"],
                    "teamName": driver_info["teamName"], "teamColour": driver_info["teamColour"],
                    "bestLapTime": best_time,
                    "currentTyre": current_session["current_tyres"].get(driver_num, "unknown"), # Added .get for safety
                    "eliminated": driver_num in current_session["eliminated_drivers"]
                })
    
    best_times_list.sort(key=lambda x: x["bestLapTime"])
    
    if best_times_list:
        fastest_time = best_times_list[0]["bestLapTime"]
        for i, entry in enumerate(best_times_list):
            entry["gap"] = f"+{entry['bestLapTime'] - fastest_time:.3f}" if i > 0 else ""
            if i > 0:
                interval = entry["bestLapTime"] - best_times_list[i-1]["bestLapTime"]
                entry["interval"] = f"{'+' if interval >=0 else ''}{interval:.3f}" # handles negative intervals if sorting changes
                entry["intervalColor"] = "green" if interval < 0.1 else ("yellow" if interval < 0.5 else "red") # Example coloring
            else:
                entry["interval"] = ""
                entry["intervalColor"] = "white"
    
    return jsonify({
        "session": {
            "name": current_session["name"], "phase": current_session["phase"],
            "circuit": current_session["circuit"], "country": current_session["country"],
            "is_active": current_session["is_active"], "time_remaining": current_session["time_remaining"]
        },
        "timing": best_times_list
    })
    
@app.route('/api/session/simulate', methods=['GET'])
def simulate_session_update():
    if current_session["is_active"]:
        update_session_lap_times()
        current_session["time_remaining"] = max(0, current_session["time_remaining"] - 2)
    return get_complete_timing()

@app.route('/api/session/start_qualifying', methods=['GET'])
def api_start_qualifying():
    """API endpoint to manually start/restart the qualifying simulation if needed"""
    # This can be used to manually trigger a restart via API if the auto-loop is not desired
    # or if you want to interrupt and restart.
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] API call to /api/session/start_qualifying received.")
    result = start_qualifying_simulation()
    return jsonify(result)

@app.route('/api/session/change/<session_type>/<circuit>', methods=['GET'])
def change_session(session_type, circuit):
    global simulation_running, simulation_thread, current_session
    
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] API call to change session to {session_type} at {circuit}.")
    if simulation_thread and simulation_thread.is_alive():
        simulation_running = False
        simulation_thread.join(timeout=5)
    
    valid_sessions = ["FP1", "FP2", "FP3", "Qualifying", "Race"]
    if session_type in valid_sessions:
        # This part will be overridden by the automatic loop if it's running qualifying.
        # For this endpoint to be truly effective with the loop, the loop might need to be paused or check session["name"]
        current_session["name"] = session_type
        current_session["circuit"] = circuit
        
        reset_session_state() # Reset according to the new session type
        # Adjust reset_session_state or QUALIFYING_STRUCTURE if other sessions have different structures.
        # For now, reset_session_state is geared towards Qualifying.

        if session_type != "Qualifying":
            current_session["phase"] = "N/A" # Or specific phases for FP/Race
            # Potentially start a different type of simulation thread if not Qualifying
            current_session["is_active"] = False # Stop auto-qualifying loop for other session types
            print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] Session changed to {session_type}. Automatic qualifying loop may be affected/paused.")

        return jsonify({
            "status": "success", 
            "message": f"Session changed to {session_type} at {circuit}. Current state: is_active={current_session['is_active']}"
        })
    else:
        return jsonify({"status": "error", "message": "Invalid session type"}), 400

# New function to manage the simulation lifecycle
def simulation_lifecycle_manager():
    global simulation_thread # So we can join it

    # Start Flask app in a daemon thread
    # It will run in the background and won't block the simulation loop.
    # It will exit when the main simulation_lifecycle_manager thread exits.
    # Important: use_reloader=False is critical when managing threads like this,
    # otherwise Flask might start two instances of your app / threads.
    flask_app_thread = threading.Thread(target=lambda: app.run(debug=True, host='0.0.0.0', port=5000, use_reloader=False))
    flask_app_thread.daemon = True
    flask_app_thread.start()
    
    # Print API endpoints (original startup messages)
    print("F1 Simulator API starting... (Flask server running in background)")
    print("Available endpoints:")
    print("  /api/sessions/current - Get current session info")
    print("  /api/drivers - Get all drivers")
    print("  /api/laptimes/current - Get current lap times")
    print("  /api/tyres/current - Get current tyre compounds")
    print("  /api/timing/complete - Get complete timing data with gaps")
    print("  /api/session/simulate - Force a simulation update")
    print("  /api/session/start_qualifying - Manually (re)start a qualifying simulation")
    print("  /api/session/change/<session_type>/<circuit> - Change session type (may interact with auto-loop)")

    # Give the Flask server a moment to initialize and print its own messages
    time.sleep(2) 

    while True: # Infinite loop for sessions
        # Ensure the session to be run is "Qualifying" for this loop.
        # If `change_session` API is called to a non-Qualifying session,
        # `start_qualifying_simulation` will reset it back to Qualifying.
        current_session["name"] = "Qualifying" # Explicitly set for this loop's intent

        print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] Main Loop: Session Started (Qualifying)")

        # This function handles resetting the session and starting the simulation thread
        start_qualifying_simulation() 
        # start_qualifying_simulation itself calls reset_session_state and prints its own startup messages.

        # Wait for the simulation_thread (started by start_qualifying_simulation) to complete
        if simulation_thread and simulation_thread.is_alive():
            simulation_thread.join() # This blocks until the qualifying_simulation_thread finishes

        # The qualifying_simulation_thread itself prints "Qualifying simulation ended."
        print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] Main Loop: Session Ended (Qualifying)")
        
        print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] Main Loop: Sleeping for 10 seconds...")
        time.sleep(10)
        # Loop continues, and start_qualifying_simulation() will reset everything for the new session.

if __name__ == "__main__":
    simulation_lifecycle_manager()