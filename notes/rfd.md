# Learning Rust from C#

## Learning Materials

- https://doc.rust-lang.org/book/

- https://microsoft.github.io/rust-for-dotnet-devs/latest/

- https://github.com/rust-lang/rustlings

## What's the same?

- General Purpose / Statically typed / Compiled
- Tooling experience you'd expect:
    - Package manager / Build System (dotnet == npm == cargo)
    - LSP/Linter (omnisharp == rust-analyzer + rustfmt == eslint + js/ts lsp)
    - Debugger (dotnet debug == lldb == node debug / chrome devtools)
    - Testing framework (xunit/nunit == cargo test == jest/mocha)
    - VSCode experience is same for all three (error squiggles, intellisense, refactoring, debug, etc)
- Similar syntax (C-style)
- Similar control flow (if, switch/match, loops)
- Similar functions 
- Similar modern language features
    - Generics
    - Lambdas
    - Pattern matching
    - Tuples
    - Collections (arrays, lists, dictionaries/maps)
    - Iterators and functional programming methods (map, filter, reduce/fold)
    - Async/await 
- Similar "standard" library features
    - Strings
    - File I/O
    - High-level and low-level Networking (sockets, tcp streams, etc.)
    - Concurrency (threads, channels)
    - Date/Time
    - Math
    - JSON serialization
- Similar frameworks available (web, game dev, cli apps, etc)
- Similar use cases (web backend, cli tools, game dev, embedded, etc)
- Memory model aside, generally the same "kind" of language
- Full-blown IDE if you like that (Visual Studio = RustRover)

## Big Differences

- Native compilation to machine code (no VM or JIT)
- Ownership and Borrowing instead of Garbage Collection
    - No need for a GC pause
    - No memory hanging around longer than necessary
    - More control over memory layout and performance
    - More complexity to learn
    - NOT manual memory management, NOT something you can mess up more easily
- Different Object Model
    - Structs and Enums instead of Classes
    - Traits instead of Interfaces
    - No Inheritance
- Options instead of nulls/nullable types
- Result Wrappers instead of exceptions
- Default to Stack Allocation
- Libraries (crates) are source-based and compiled into the binary (static linking)
- Generic traits (e.g. `From`) don't have an equivalent in C#
- Longer Compile Times

## Small Differences

- Small internal library. Need libraries for common tasks (e.g., HTTP, JSON)
- Stricter Linter
- Default to Immutable
- Expression-based
- Shadowing
- Namespacing / Modules require directory structure (like Java)
- No `new` keyword for instantiation, use `StructName { field: value }` syntax or a "factory method"
- Syntactic differences
    - Types are postfixed rather than prefixed (e.g., `let x: i32` vs `int x`)
    - snake_case for variables and functions, CamelCase for types and traits
    - Lambdas have a special syntax that doesn't look like a function declaration

## Culture Differences

- More focus on performance
- Closer to JavaScript in terms of OSS ecosystem and velocity
- Less "enterprisey"
 
## Things recently added to C# that are in Rust

- Pattern Matching
- Source Generators (macros in Rust)
- `switch` expressions (`match` in Rust)
- If expressions (`if let` in Rust)
- `Span<T>` and (slices in Rust)
- `ReadOnlySpan<char>` (string slices in Rust)
- `MemoryOwner<T>` (ownership and borrowing in Rust)

## My Experience

- It took me about a month (part time) to get comfortable enough to write *something* non-trivial
    in Rust (HL7.)
- It's been about two years of casual use (a few hours a week) to get comfortable enough to
  write "good" Rust code that takes advantage of the language features and idioms without needing
  to look up how to do things too often.
- At this point I probably spend about 70% of my time in Rust and 30% in C#, web, python, etc.
- I'm still learning new things and hopefully always will be.

### General Advice

- I did not find it useful to think of Rust as "a better C++" or "a systems programming language"
    - Memory is entirely managed and safe, it is just not garbage collected
    - You don't work with pointers or allocating/deallocating memory directly.
    - More useful to think of it a high-level language where you need to "help" the compiler 
      understand how to manage memory in exchange for native performance
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
- It is not an language to learn, but it is not as hard as C++ or F# 
    - The ownership model and borrow-checker are the hardest parts to learn
    - The type system is simpler than C#'s, but different enough that it takes some getting used to
    - The lack of nulls/exceptions is a big change, but the `?` operator make it manageable
- Get used to bigger and less files/directories
- There are a lot of syntax things that look familiar but behave differently
    - `&` is for borrowing (like `ref` in C#), not address-of
    - `!` is a macro name suffix not a null-forgiving operator.
    - lambdas are tricky (as mentioned above) but are significantly cheaper than C# lambdas, or
      especially javascript lambdas
    - Several common methods work the same, but have very different performance characteristics
        - `split` is a very cheap method that returns references into the original string
          (like `Span<char>` in C#), not a method that allocates new strings
        - Regular expressions (from the `regex` crate) are more limited, but are significantly
          faster than C# regex because they don't support back-references
    - In general, check your assumptions.

### My Struggles

#### Memory Model

- Initially, it felt pretty annoying and restrictive
    - The "fighting the borrow-checker" meme is (a bit) real early on.
- I defaulted to using `.clone()` too often
    - Partly because it was so much less expensive than I expected
- I made a lot more progress once I started defaulting to using references/borrowing
    - The "fighting the borrow-checker" meme is really overstated
    - The compiler error messages are *really* good at explaining what the problem is and how to fix it
      once you understand the basics and once you understand Rust's terminology
    - Your function really doesn't need to own or mutate an argument most of the time
- I put off really understanding *basic* lifetime declarations, and that was a mistake.
    - You need to understand the basics of lifetime declarations to address many common borrow-checker errors
- I struggled briefly because I thought that lifetime declarations extended or modified lifetimes
    - They don't "do anything."  They just help the compiler understand relationships between references.
- I overestimated the importance of knowing all of the smart pointer types up-front
    - You can get to these when you need them, and it's easier to understand them when you have a use case

#### Type System

- Getting used to putting "methods" in `impl` blocks wasn't too hard, but something different Not having default constructors by default was something to get used to. You have to either:
    - Derive the `Default` trait
    - Write your own "factory method" (e.g., `new()`)
    - Make a new instance with complete field initialization (e.g., `let x = Person { name: String::from("Bob"), age: 30 };`)
- The normal pattern for replacing inheritance is to use enums, not structs and traits
    - Structs and traits felt more intuitive
    - Enums are a lot easier (no boxing, no dynamic dispatch)
- I had a weird tendency to think of derived traits as making my types heavier or cost more,
  but they are basically free if you don't use them and necessary if you do.  In either
  case, they aren't affecting the type, they are just generating functions that operate on the type.
- As with a few other things in Rust, I sometimes worried about explicitly putting certain
  derives on most/all of my types (like `Clone` and `Debug`), but this is part of rust being
  explicit in just about everything.

#### Options vs. Nulls

- Had exposure to this with F#/OCaml
- Thought this would be a lot more annoying than it is.  Things that make this easy:
    - The `?` propagating operator
    - The many convenient methods on `Option<T>` for working with optional values
- You can still "just not worry about nulls" by using `unwrap()` or `expect()` or leaning on
  `?` to propagate `None` values and make the caller deal with them
    - But you have to do it explicitly, which means it's easy to track down the places where "nulls" can occur.
    - This basically gives you an experience similar to having nullable reference types/checking turned on in C#
      (It's not the same but it *feels* the same.)

#### Results vs. Exceptions

- The problem is basically that there is no inheritance, so no common base type for errors
  so if you want to propegate errors up the call stack, you have to convert them at each step,
  and you have to write conversion code for each error type you want to convert.
  This is a really awful experience. 
- There are libraries that everyone uses that solve this problem.
- The easiest way around this is to use `anyhow`
    - Stores errors in something like a `Box<dyn Error>` that can live on the
        heap and be passed around easily as one type.
- There are other libraries like `thiserror` that don't require pushing errors to the heap
  if the performance or typing is important to you.
- Using anyhow and the `?` operator makes working with `Result<T, E>` pretty easy and very
  similar to working with exceptions in C#, with these caveats:
    - You have to explicitly mark functions that can fail with `-> Result<T, E>`
    - You have to explicitly use `?` to propagate errors
    - You use `match` or methods on `Result<T, E>` to handle errors instead of `try/catch`

#### Declarative Macros ("Template" macros)

- Off-putting syntax and behavior at first.
- Actually pretty easy to understand and use.
- Can be hard to read, and the LSP support isn't great.
- Still worth using for heavily repetitive code or boilerplate code.
- Need to balance trade-offs of readability vs. boilerplate reduction.

