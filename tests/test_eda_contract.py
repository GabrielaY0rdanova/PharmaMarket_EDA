from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]


class EdaContractTests(unittest.TestCase):
    def test_runner_stops_on_errors_and_uses_relative_includes(self):
        text = (ROOT / "run_full_eda.sql").read_text(encoding="utf-8")
        self.assertIn("\\set ON_ERROR_STOP on", text)
        self.assertIn("\\ir scripts/00_InitDatabase.sql", text)
        self.assertIn("\\ir tests/13_ValidationGate.sql", text)

    def test_analysis_runner_executes_every_analysis_script(self):
        text = (ROOT / "run_all_analysis.sql").read_text(encoding="utf-8")
        self.assertIn("\\set ON_ERROR_STOP on", text)
        self.assertIn("\\encoding UTF8", text)
        for number in range(3, 13):
            self.assertIn(f"\\ir scripts/{number:02d}_", text)

    def test_load_uses_parameterized_copy_and_no_machine_specific_path(self):
        text = (ROOT / "scripts/02_LoadSourceData.sql").read_text(encoding="utf-8")
        self.assertIn("FROM :'medicine_file'", text)
        self.assertNotIn("E:/Data Analysis", text)

    def test_pack_price_nulls_have_an_explicit_segment(self):
        text = (ROOT / "scripts/09_DataSegmentation.sql").read_text(encoding="utf-8")
        self.assertIn("WHEN ps.pack_price IS NULL", text)

    def test_export_defaults_to_project_source_data_directory(self):
        text = (ROOT / "scripts/01_ExportSourceData.py").read_text(encoding="utf-8")
        self.assertIn('Path(__file__).resolve().parents[1] / "source_data"', text)
        self.assertNotIn("My Projects\\PharmaMarket_EDA", text)


if __name__ == "__main__":
    unittest.main()
