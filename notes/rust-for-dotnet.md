# Presentation Notes - Rust for .NET Developers
- Very useful website: https://microsoft.github.io/rust-for-dotnet-devs/latest/

## Rust

- Having your cake and eating it too
    - Fast non-garbage collected memory management without the complexity of manual memory management
    - OOP without lasagna code and without a complex dispatch system
    - Nullability without null reference exceptions and without having to unwrap optionals everywhere
    - Error handling without easily ignored errors and without having to check for errors everywhere
    - High-level abstractions without runtime overhead (Zero-cost abstractions)
    - Safe concurrency without a garbage collector
    - "If it compiles, it works" without a weird language or complex type system
    - Powerful metaprogramming without the performance hit of reflection and RTTI

## Memory Model

- Previous trade-off:
    - Garbage Collection (GC)
        - Automatic memory management
        - Can introduce latency and unpredictability in performance
    - Manual Memory Management
        - More control over memory usage
        - Higher risk of memory leaks and undefined behavior
        - Requires significantly more effort from the developer

- Three places memory can be allocated:
    - Static Memory
        - Allocated at compile time and exists for the duration of the program
        - Fixed size at compile time
        - Used for global variables and constants
    - Stack
        - Fast allocation and deallocation
        - Fixed size at compile time
        - Used for local variables and function call management
    - Heap
        - Slower allocation and deallocation
        - Dynamic size at runtime
        - Used for data that needs to live beyond the scope of a function or has a size not known at compile time


- Rust's ownership model
    - Basically every value in Rust is a value/stack type
        - When heap data is needed, it's pointer lives in a value/stack type and it's allocation/deallocation
          is managed by the enclosing value/stack type.
    - Each value in Rust has a single "owner"
    - When the owner goes out of scope, the value is dropped and memory is freed
    - Borrowing allows references to a value without taking ownership
        - Immutable references (`&T`) allow read-only access
        - Mutable references (`&mut T`) allow read and write access, but only one mutable reference at a time
        - Rust enforces these rules at compile time to ensure memory safety without a garbage collector
- Lifetimes
    - Sometimes rust needs help understanding that we promise to keep a reference valid
    - Lifetimes are a way to annotate that we guarantee a reference will stay alive as long as some other reference
    - Explicit lifetimes can be added to function signatures and structs to clarify relationships between references
    - Declaring a lifetime does NOT change the lifetime of a value, it just promises that our usages will 
      respect constraints around reference lifetimes.

- Memory Management Containers
    - `Box<T>`: Heap allocates the value, and puts a pointer to it on the stack (still managed through the ownership system)
    - `Rc<T>`: Heap allocates the value and makes a "clonable" pointer to it (reference counted, single-threaded)
    - `Arc<T>`: Thread-safe version of `Rc<T>` (atomic reference counting)
    - `RefCell<T>`: Wraps a value in a box that enables mutability even through a reference to the box.  
        - This is kind of an escape hatch that allows you to exempt a value from the usual borrowing rules.
        - Enforces borrowing rules at runtime instead of compile time (single-threaded)
    - `Mutex<T>`: Thread-safe version of `RefCell<T>` (enables interior mutability with locking)

- My Experience
    - It takes a bit of time to get used to the ownership model and borrowing rules
    - Initially, it felt pretty annoying and restrictive
        - The "fighting the borrow-checker" meme is (a bit) real.
    - Early on I was inclined to completely avoid the borrow-checker:
        - Using `.clone()` too often
            - Partly because it was so much less expensive than I expected
        - Using `Rc` and `Arc` too often
    - I made a lot more progress once I started defaulting to using references/borrowing
        - The "fighting the borrow-checker" meme is really overstated
        - The compiler error messages are *really* good at explaining what the problem is and how to fix it
          once you understand the basics and once you understand Rust's terminology
    - I put off really understanding *basic* lifetime declarations, and that was a mistake.
        - You need to understand the basics of lifetime declarations to address many common borrow-checker errors
    - I struggled a bit because I thought that lifetime declarations extended or modified lifetimes
        - They don't "do anything."  They just help the compiler understand relationships between references.
    - I overestimated the importance of knowing all of the smart pointer types up-front
        - You can get to these when you need them, and it's easier to understand them when you have a use case

## Type System

- Previous trade-off:
    - Weak Type Systems
        - Simpler and more flexible
        - Can lead to runtime errors and unexpected behavior
    - Object-Oriented Programming (OOP) Type Systems
        - Encapsulation, inheritance, and polymorphism
        - Can lead to complex hierarchies and runtime overhead
        - Hard to add behaviors to types after the fact
        - Need to type a lot more code (prior to type inference)

- No OOP (in the java/c# sense)
    - No classes, no inheritance, no virtual methods
    - Only structs, enums, and traits
- Structs
    - Similar to classes in C# but without methods and without inheritance
    - Can have associated functions and methods defined in `impl` blocks
    - Most types are handled via structs
    - Handle most use cases for classes
    - Useful for open inheritance
        - You do need to use boxing/dyn/impl to get polymorphism with structs because
          the size of an argument or field must be known at compile time.
- Enums
    - Discriminated unions that can hold different types of data
    - Useful for closed inheritance
    - Covers most of the use cases for inheritance and polymorphism
        - Inside-out version of a class hierarchy
        - Base class "knows" about all derived classes
        - Dispatch is handled via pattern matching, not virtual method tables
    - You do not need boxing/dyn/impl to get polymorphism with enums because
      the size of an enum is known at compile time (it is the size of the largest variant plus a tag)

- Traits
    - Similar to interfaces in C# but can also provide default method implementations
    - Allow for polymorphism without inheritance
    - Can be used to define shared behavior across different types
    - Enable ad-hoc polymorphism (similar to C# extension methods)
    - Applying a trait to a type is done outside the type definition

- Derive Macros
    - A common code-generaton technique in Rust is the use of derive macros
    - Rust can automatically implement certain traits for your types using the `#[derive]` attribute
    - Commonly derived traits include `Debug`, `Clone`, `Copy`, `PartialEq`, and `Eq`
    - Very cool.  There is nothing like this in C#.
        - In C#, some things are just built-in to every type
        - Sometimes you can get some of this with attributes and a library.
        - Very recently, C# added source generators, which can do similar things (but they are a late feature.)

- My Experience
    - Getting used to putting "methods" in `impl` blocks is really nothing.
    - Inheritance doesn't come up enough that I really care, and when it does, the enum/trait 
      thing usually feels more appropriate anyway.
    - Struct polymorphism via traits requires some extra work with Boxing, but makes more sense
      when you think about size needing to be known at compile time.
    - I had a weird tendency to think of derived traits as making my types heavier or cost more,
      but they are basically free if you don't use them and necessary if you do.  In either
      case, they aren't affecting the type, they are just generating functions that operate on the type.
    - As with a few other things in Rust, I sometimes worried about explicitly putting certain
      derives on most/all of my types (like `Clone` and `Debug`), but this is part of rust being
      explicit in just about everything.

## Strings

- Strings are very different in Rust
    - `String`s are mutable
    - There is a second type `&str` that is a "string slice" (immutable reference to all or part of a `String`)
    - `String` is a struct that contains a pointer to heap-allocated data, a length, and a capacity
    - `&str` is just a pointer and a length
    - String literals are `&'static str` (immutable reference to a string that is baked into the binary)
        - This is because static data doesn't have/need an owner, it's just always there.
        - You also can't modify static data, so it makes sense that it's an immutable reference.
    - Strings in Rust are UTF-8 encoded
        - This means that directly indexing into a string is not allowed, because characters are variable
          length in UTF-8
        - You can iterate over the characters in a string, but this is more expensive than iterating over
          bytes.
        - You can get a byte slice (`&[u8]`) from a string if you need to work with raw bytes.
        - You need to be careful not to mix up byte indices and character indices.


## Nullability

- Rust does not have null references
    - Instead, it uses the `Option<T>` enum to represent a value that can be either `Some(T)` or `None`
    - This forces developers to explicitly handle the absence of a value, reducing the risk of null
        reference exceptions.
    - There are many convenient methods on `Option<T>` to work with optional values
        - `unwrap()`, `expect()`, `map()`, `and_then()`, etc.

- My Experience
    - Was worried that this would be really painful
    - It's easier than it seems because of:
        - The `?` propagating operator
        - The many convenient methods on `Option<T>` for working with optional values
    - You can still "just not worry about nulls" by using `unwrap()` or `expect()` or leaning on
      `?` to propagate `None` values and make the caller deal with them
        - But you have to do it explicitly, which means it's easy to track down the places where "nulls" can occur.
        - This basically gives you a much stronger and enforced version of nullable reference types in C#.

## Error Handling

- Rust does not have exceptions
    - Instead, it uses the `Result<T, E>` enum to represent either a success (`Ok(T)`) or an error (`Err(E)`)
    - This forces developers to explicitly handle errors, reducing the risk of ignored errors
    - The `?` operator can be used to propagate errors up the call stack, making error handling more ergonomic
    - Because there is no inheritance, by default you have to convert error types explicitly to propagate.  This
      is usually heavy-handed, but can be avoided by using these helper crates:
        - `anyhow`: In practice, this lets you just use Strings or `Box<dyn Error>` for error types and
          still use `?` to propagate errors.
        - `thiserror`: For libraries where you want to define your own error types but make it easy to convert
          between them.  This is more performant than `anyhow` because it does not box errors, but it requires
          you to define your own error types.

- My Experience
    - The two crates mentioned above (`anyhow` and `thiserror`) are a must-have.
        - Use `anyhow` for applications and quick prototypes where you don't care about the type of
          an error.
        - Use `thiserror` for libraries, so that people who want "Typed" errors can have them.
        - This decision is similar to this choice in C#: Do you want to throw `Exception` or
          define your own exception types and throw those?
    - Without these crates, error handling is pretty heavy-handed and tedious.
        - You have to define your own error types and implement conversions between them
          to propagate errors up the call stack.

## Macros

- C# recently added source generators, which can do some of what Rust macros can do.
- Rust has two types of macros: declarative macros (macro_rules!) and procedural macros.
    - Declarative macros are similar to C# preprocessor macros but more powerful and flexible.
    - Procedural macros are functions that operate on the abstract syntax tree (AST) of the code,
      allowing for complex code generation and transformations.
- Our code generally only includes declarative macros.
- But we *use* both
- Declarative macros allow for entire embedded DSLs
    - Example: Web frameworks that want a razor-like syntax for embedding HTML in Rust code
      are not a special case - there is just a procedural macro that basically says
      "take everything inside these braces and treat it as HTML with embedded Rust expressions"
- My experience
    - Using them is easy and allows for RoR type "magic."
    - Declarative macros are a pretty easy to write (just kind of a code template.)  But kind of
      awkward to read, and don't always behave great with LSP/IntelliSense.  I only use them to get
      rid of large repetitive code patterns.
    - I have not written or even looked at procedural macros.

## Oddities

- Expression based (everything returns a value)
    - So you can do things like:
      ```rust
      let x = if condition {
          value1
      } else {
          value2
      };
      ```
    - This is similar to the ternary operator in C#, but more general and more consistent
    - Omitting the semicolon at the end of a block makes the block return a value
        - This is a common source of confusion for beginners
- No classes, no inheritance, no virtual methods
- Types postfixed, not prefixed
- Constructors are not special cased, just factory methods
- Variable shadowing
- Lambdas are trickier in general (typing, move semantics, etc.)
- Modules require directory structure (like java)
- Snake case for most things, but CamelCase for types
- Build-times can be slow, due to:
    - Static linking of libraries (source is compiled)
    - Heavy use of code generators (macros, derives, generics, etc.)
    - Extensive compile-time checks and optimizations
    - Incremental compilation is improving, but still not as fast as C#'s JIT compilation

## Very General Advice

- I did not find it useful to think of Rust as "a better C++" or "a systems programming language"
    - Memory is entirely managed and safe, it is just not garbage collected
    - More useful to think of it a high-level language where you need to "help" the compiler 
      understand how to manage memory.
    - YMMV.  Evie came to Rust from (mostly) ASM/C, so she would probably tell you the opposite.
- On the imperative -> functional spectrum, Rust sits *slightly* more functional than C#
    - Expression-based
    - Discriminated Unions
    - Options and Results
- The use of libraries is more similar to javascript than to C#
    - Many things are not "built-in"
    - There are a common set of crates that you'll end up using in most projects:
        - `tracing` for logging
        - `anyhow` and/or `thiserror` for error handling
        - `serde` for serialization/deserialization
        - `tokio` for async programming
        - `clap` for command-line argument parsing
        - `chrono` for date/time handling
- It is not a trivial language to learn, but it is not as hard as C++ or F# 
    - The ownership model and borrow-checker are the hardest parts to learn
    - The type system is simpler than C#'s, but different enough that it takes some getting used to
    - The lack of exceptions is a big change, but the `?` operator make it manageable
- Get used to bigger and less files/directories
- There are a lot of syntax things that look familiar but behave differently
    - `let` is for variable declaration, not assignment
    - `&` is for borrowing (like `ref` in C#), not address-of
    - `!` is a macro name suffix not a null-forgiving operator.
    - lambdas are tricky as mentioned above but are significantly cheaper than C# lambdas, or
      especially javascript lambdas
    - Several common methods work the same, but have very different performance characteristics
        - `split` is a very cheap method that returns references into the original string
          (like `Span<char>` in C#), not a method that allocates new strings
        - Regular expressions (from the `regex` crate) are more limited, but are significantly
          faster than C# regex because they don't support back-references

## Rust Memory Model

- You can only have value types (structs or primitives)
    - They get deallocated when they go out of scope
    - This "deallocation" can do other things (destructors)
- First problem = passing these to another function:
    - Who is responsible for deallocating the value?
    - C# solution = copy the value (automatically)
        - Rust does this automatically for some values (Copy trait)
        - For most types, this is done manually (Clone trait)
    - Another C# solution = pass by reference
    - Third solution = pass the whole value *and* the responsibility for deallocation
        - This is called "moving" in Rust
        - The original variable is no longer valid after the move
- Next problem = what about dynamic sized values like Strings?
    - There are structs in Rust that contain pointers to heap-allocated data
    - The struct itself is a value type, so it gets deallocated when it goes out
      of scope, and the destructor for the struct deallocates the heap data
    - So we aren't really working directly with heap data, we are working
      with value types that manage heap data for us
- So we have three solutions:
    - Copying (Copy/Clone traits)
    - Borrowing (references, `&T` and `&mut T`)
    - Moving (default for most types)
- Copying is straightforward, but:
    - Expensive for large types
    - Doesn't let us modify the original value
- Moving is relatively straightforward
    - Transfers ownership of the value to the new variable
    - Original variable is no longer valid
    - We can't really share data this way either
- Borrowing (reference types) could solve all of this!
    - Everything just has a reference ("pointer") to the value and they can
      all read/write it all they want.
    - This is basically what C# does with reference types.

- This is the answer, but has some problems that we need to solve:
    - What if two different parts of our program have a value and are changing it
        - Particularly if they are on different threads
    - What if some part stores the reference in a long-lived place and the original
      value goes out of scope?
    - Who is responsible for deallocating the value?
    - C#'s answer = Garbage Collection
        - Store (almost) everything on the heap and have a background process
          that periodically looks for values that are no longer referenced and
          deallocates them.
        - Automatic memory management
        - Can introduce latency and unpredictability in performance
        - Non-deterministic destruction (you have no idea when an object will be finalized and
          when memory will be freed)
    - Rust's answer = Borrowing rules
        - The "owner" of the data (last function that has it as a non-reference variable)
          is still responsible for deallocating it and will do so when it goes out of scope
          as usual.
        - You can pass references with a few rules:
            - You can have any number of immutable references (`&T`) to a value OR
            - You can have only one mutable reference (`&mut T`) to a value
            - You cannot have mutable and immutable references to a value at the same time
            - If you try to store that reference or do anything that would cause it to
              stick around after your function returns, you are going to have to convince
              the compiler that the reference will still be valid (lifetime annotations)
        - These rules are enforced at compile time by the borrow-checker
            - If you violate the rules, your code won't compile

- We still need heap data (for variable length data, indirection, etc.)
- Rust (safe) doesn't let you directly allocate heap data, but provides several value types that
  wrap and manage heap data for you:
    - `String` - a heap-allocated, growable string.  Pointer and length on the stack, buffer on the heap.
    - `Vec<T>` - a heap-allocated, growable array.  Pointer and length on the stack, buffer on the heap.
    - `Box<T>` - Stores the wrapped value on the heap.  Pointer on the stack, value on the heap.  Useful
      for when you need indirection (e.g. recursive types.)
    - `Rc<T>` - Reference counted pointer for single-threaded scenarios.  Pointer on the stack, count and
       value on the heap.  If you clone an `Rc`, you get a copy of the pointer and the count is incremented.
       When an `Rc` is dropped, the count is decremented, and if the Rc is the last one, the value is deallocated.
    - `Arc<T>` - Atomic reference counted pointer for multi-threaded scenarios.  Same as `Rc<T>`, but the count is
       updated atomically so it is safe to use across threads.
    - `RefCell<T>` - Wrapper around mutable heap data where the reading/writing rules are enforced at runtime.
       Pointer on the stack, value and borrow state on the heap.  Useful for single-threaded scenarios where
       you need to read/write data in a way that the borrow-checker can't verify at compile time.
    - `Mutex<T>` - Wrapper around mutable heap data where the reading/writing rules are enforced at runtime with locking.
       Pointer on the stack, value and lock state on the heap.  Basically a thread-safe version of `RefCell<T>`.

