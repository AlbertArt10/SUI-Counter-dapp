#[allow(
	duplicate_alias,
	lint(public_entry)
)]
module counter::counter {

	use sui::object::{UID, ID};
	use sui::tx_context::TxContext;
	use sui::tx_context;
	use sui::transfer;
	use sui::event;
	use sui::clock::{Clock, timestamp_ms};

	//
	// ─────────────────────────────────────────────────────────────
	//   STRUCTS
	// ─────────────────────────────────────────────────────────────
	//

	// Main counter object
	public struct Counter has key {
		id: UID,
		owner: address,
		value: u64,
		created_at: u64,
	}

	// Event for counter creation
	public struct CounterCreated has copy, drop {
		owner: address,
		counter_id: ID,
		created_at: u64,
	}

	// Event for counter increment
	public struct CounterIncremented has copy, drop {
		owner: address,
		counter_id: ID,
		new_value: u64,
	}

	//
	// ─────────────────────────────────────────────────────────────
	//   ERRORS
	// ─────────────────────────────────────────────────────────────
	//

	// Only the owner can increment
	const E_NOT_OWNER: u64 = 1;

	//
	// ─────────────────────────────────────────────────────────────
	//   FUNCTIONS
	// ─────────────────────────────────────────────────────────────
	//

	// Creates a new counter
	public entry fun create_counter(clock: &Clock, ctx: &mut TxContext) {
		use sui::object;

		let sender = tx_context::sender(ctx);

		// Build the counter object
		let counter = Counter {
			id: object::new(ctx),
			owner: sender,
			value: 0,
			created_at: timestamp_ms(clock),
		};

		// Emit creation event
		event::emit(CounterCreated {
			owner: sender,
			counter_id: object::id(&counter),
			created_at: counter.created_at,
		});

		// Transfer to caller
		transfer::transfer(counter, sender);
	}

	// Increments the counter
	public entry fun increment(counter: &mut Counter, ctx: &TxContext) {
		use sui::object;

		let sender = tx_context::sender(ctx);

		// Check owner
		if (sender != counter.owner) {
			abort E_NOT_OWNER
		};

		// Update value
		counter.value = counter.value + 1;

		// Emit increment event
		event::emit(CounterIncremented {
			owner: sender,
			counter_id: object::id(counter),
			new_value: counter.value,
		});
	}

	// Returns the current value
	public fun get_value(counter: &Counter): u64 {
		counter.value
	}
}
