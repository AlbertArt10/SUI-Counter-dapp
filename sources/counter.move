#[allow(
    duplicate_alias,
    unused_use,
    unused_variable,
    unused_const,
    unused_field,
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

    public struct Counter has key {
        id: UID,
        owner: address,
        value: u64,
        created_at: u64,
    }

    public struct CounterCreated has copy, drop {
        owner: address,
        counter_id: ID,
        created_at: u64,
    }

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

    const E_NOT_OWNER: u64 = 1;

    //
    // ─────────────────────────────────────────────────────────────
    //   FUNCTIONS
    // ─────────────────────────────────────────────────────────────
    //

    /// Create a counter with real timestamp from the global Clock (object 0x6)
    public entry fun create_counter(clock: &Clock, ctx: &mut TxContext) {
        use sui::object;

        let sender = tx_context::sender(ctx);

        // Create the counter object
        let counter = Counter {
            id: object::new(ctx),
            owner: sender,
            value: 0,
            created_at: timestamp_ms(clock),   // REAL TIMESTAMP in ms
        };

        // Emit event
        event::emit(CounterCreated {
            owner: sender,
            counter_id: object::id(&counter),
            created_at: counter.created_at,
        });

        // Give ownership to the sender
        transfer::transfer(counter, sender);
    }

    public entry fun increment(_counter: &mut Counter, _ctx: &TxContext) {
        // TODO implement next step
    }

    public fun get_value(counter: &Counter): u64 {
        counter.value
    }
}
