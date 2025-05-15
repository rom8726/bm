use std::collections::HashMap;
use std::fs;
use std::path::{PathBuf};
use serde::{Serialize, Deserialize};
use dirs::config_dir;

#[derive(Serialize, Deserialize, Debug, Default)]
pub struct Bookmarks {
    pub map: HashMap<String, PathBuf>,
}

impl Bookmarks {
    pub fn load() -> Self {
        let path = Self::config_path();
        if path.exists() {
            let data = fs::read_to_string(&path)
                .expect("Failed to read bookmarks.json");
            serde_json::from_str(&data)
                .expect("Failed to parse bookmarks.json")
        } else {
            Bookmarks::default()
        }
    }

    pub fn save(&self) {
        let path = Self::config_path();
        let parent = path.parent().unwrap();
        fs::create_dir_all(parent).expect("Failed to create ~/.config/bm/");
        let data = serde_json::to_string_pretty(&self)
            .expect("Failed to serialize bookmarks");
        fs::write(path, data).expect("Failed to write bookmarks.json");
    }

    pub fn config_path() -> PathBuf {
        config_dir()
            .expect("Failed to get config dir")
            .join("bm")
            .join("bookmarks.json")
    }
}
