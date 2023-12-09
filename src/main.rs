use std::collections::HashMap;

use anyhow::Result;

const REGEX: &str = r"(\[\{)(.*?)(\}\])";

fn main() -> Result<()> {
    let regex = regex::Regex::new(REGEX)?;
    let templates = std::fs::read_dir("templates")?;

    for template in templates {
        let mut variables: HashMap<&str, &str> = HashMap::new();
        variables.insert("ARTIFACT_NAME", "sshdb_backend");
        variables.insert("ENTRYPOINT", "\"/app/sshdb_backend\"");

        let path = template?.path();
        let content = std::fs::read_to_string(path)?;
        let matches = regex.find_iter(&content);
        let mut tmp = content.to_string();

        for m in matches {
            let mut key = m.as_str().trim_start_matches("[{").trim_end_matches("}]");

            if key.contains("|") {
                let mut split = key.split("|");
                key = split.next().unwrap();
                let value = split.next().unwrap();
                variables.insert(key, value);
            }

            let value = variables.get(key).unwrap_or(&"");
            tmp = tmp.replace(m.as_str(), value);
        }

        println!("{}", tmp);
    }
    Ok(())
}
