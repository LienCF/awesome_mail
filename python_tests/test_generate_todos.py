import importlib.util
import math
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
MODULE_PATH = ROOT / 'generate_todos.py'

spec = importlib.util.spec_from_file_location('generate_todos_module', MODULE_PATH)
module = importlib.util.module_from_spec(spec)
assert spec is not None
assert spec.loader is not None
spec.loader.exec_module(module)


class GenerateTodosTest(unittest.TestCase):
    def test_generate_todos_returns_pending_batch_descriptions(self) -> None:
        todos = module.generate_todos()

        self.assertIsInstance(todos, list)
        self.assertGreater(len(todos), 0)
        self.assertTrue(all(todo['status'] == 'pending' for todo in todos))
        self.assertTrue(todos[0]['description'].startswith('Batch 1: Analyze '))
        self.assertIn(
            'awesome_mail_flutter/lib/generated/l10n/app_localizations.dart',
            todos[0]['description'],
        )
        self.assertIn(
            'awesome_mail_flutter/lib/core/background/sync_task.freezed.dart',
            todos[0]['description'],
        )

    def test_generate_todos_batch_count_matches_source_list(self) -> None:
        source = MODULE_PATH.read_text(encoding='utf-8')
        files_block = source.split('files: str = """', 1)[1].split('"""', 1)[0]
        file_list = [line.strip() for line in files_block.splitlines() if line.strip()]
        expected_batch_count = math.ceil(len(file_list) / 5)

        todos = module.generate_todos()

        self.assertEqual(len(todos), expected_batch_count)
        self.assertTrue(
            all(
                todo['description'].startswith(f'Batch {index}: Analyze ')
                for index, todo in enumerate(todos, start=1)
            )
        )


if __name__ == '__main__':
    unittest.main()
