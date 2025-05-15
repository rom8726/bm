mod bookmarks;

use clap::{Parser, Subcommand};
use std::env;
use crate::bookmarks::Bookmarks;
// use std::path::PathBuf;

#[derive(Parser)]
#[command(name = "bm")]
#[command(version = "0.1")]
#[command(about = "Filesystem path bookmark tool")]
struct Cli {
    #[command(subcommand)]
    command: Option<Command>,
}

#[derive(Subcommand)]
enum Command {
    /// Save current directory as alias
    Save {
        alias: String,
    },
    /// Delete alias
    Delete {
        alias: String,
    },
    /// List all aliases
    List,
    /// Print path for alias
    Go {
        alias: String,
    },
}

fn main() {
    let cli = Cli::parse();

    match cli.command {
        Some(Command::Save { alias }) => {
            let cwd = env::current_dir().unwrap();
            let mut bookmarks = Bookmarks::load();
            bookmarks.map.insert(alias, cwd);
            bookmarks.save();
        }
        Some(Command::Delete { alias }) => {
            let mut bookmarks = Bookmarks::load();

            if bookmarks.map.remove(&alias).is_some() {
                bookmarks.save();
                println!("Alias '{}' removed", alias);
            } else {
                eprintln!("Alias '{}' not found", alias);
                std::process::exit(1);
            }
        }
        Some(Command::List) => {
            let bookmarks = Bookmarks::load();

            if bookmarks.map.is_empty() {
                println!("Empty list");
            } else {
                for (alias, path) in bookmarks.map.iter() {
                    println!("{:<15} -> {}", alias, path.display());
                }
            }
        }
        Some(Command::Go { alias }) => {
            let bookmarks = Bookmarks::load();

            match bookmarks.map.get(&alias) {
                Some(path) => {
                    println!("{}", path.display());
                }
                None => {
                    eprintln!("Alias '{}' not found", alias);
                    std::process::exit(1);
                }
            }
        }
        None => {
            println!("Use --help");
        }
    }
}
