#[test_only]
module counter::counter_tests {

	use sui::test_scenario as ts;
	use sui::clock::Clock;
	use counter::counter;

	/// =====================================================================
	/// TEST 1 — create_counter creates a counter with value 0
	/// =====================================================================
	#[test]
	fun test_create_counter() {
		let owner = @0xA;

		// Start a new scenario
		let mut s = ts::begin(owner);
		ts::create_system_objects(&mut s);

		// TX1 — create_counter
		{
			// Take Clock (shared) from inventory
			let clock = ts::take_shared<Clock>(&s);

			// Get &mut TxContext from scenario
			let ctx = ts::ctx(&mut s);

			// Call entry function to create a counter
			counter::create_counter(&clock, ctx);

			// Put Clock back in inventory
			ts::return_shared(clock);

			// Close the transaction
			ts::next_tx(&mut s, owner);
		};

		// Now the counter is in the owner’s inventory
		let ctr = ts::take_from_address<counter::Counter>(&s, owner);
		assert!(counter::get_value(&ctr) == 0, 100); // Verify value is 0

		// Return the counter to avoid "leaking"
		ts::return_to_address(owner, ctr);

		// End the scenario
		ts::end(s);
	}

	/// =====================================================================
	/// TEST 2 — increment by owner → value becomes 1
	/// =====================================================================
	#[test]
	fun test_increment_by_owner() {
		let owner = @0xA;

		// Start a new scenario
		let mut s = ts::begin(owner);
		ts::create_system_objects(&mut s);

		// TX1 — create_counter
		{
			// Take Clock (shared) from inventory
			let clock = ts::take_shared<Clock>(&s);

			// Get &mut TxContext from scenario
			let ctx1 = ts::ctx(&mut s);

			// Create a new counter
			counter::create_counter(&clock, ctx1);

			// Return Clock to inventory
			ts::return_shared(clock);

			// Close the transaction
			ts::next_tx(&mut s, owner);
		};

		// The owner takes the counter from inventory
		let mut ctr = ts::take_from_address<counter::Counter>(&s, owner);

		// TX2 — increment by owner
		{
			ts::next_tx(&mut s, owner);
			let ctx2 = ts::ctx(&mut s);
			counter::increment(&mut ctr, ctx2);
		};

		// Verify that the value is now 1
		assert!(counter::get_value(&ctr) == 1, 200);

		// Return the counter to the owner’s inventory
		ts::return_to_address(owner, ctr);

		// End the scenario
		ts::end(s);
	}
}
