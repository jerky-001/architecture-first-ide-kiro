pub mod parser;
pub mod graph;
pub mod analysis;

use std::error::Error;
use parser::CodeParser;
use graph::DependencyGraph;
use analysis::RiskAnalyzer;

pub struct DevForgeCore {
    parser: CodeParser,
    graph: DependencyGraph,
    analyzer: RiskAnalyzer,
}

impl DevForgeCore {
    pub fn new() -> Self {
        Self {
            parser: CodeParser::new(),
            graph: DependencyGraph::new(),
            analyzer: RiskAnalyzer::new(),
        }
    }

    pub fn analyze_project(&self, path: &str) -> Result<String, Box<dyn Error>> {
        // 1. Parse code files
        let specific_files = self.parser.scan_directory(path)?;
        
        // 2. Build dependency graph
        let graph = self.graph.build_from_files(&specific_files);
        
        // 3. Analyze risks
        let risk_report = self.analyzer.calculate_risks(&graph);
        
        Ok(risk_report)
    }
}
