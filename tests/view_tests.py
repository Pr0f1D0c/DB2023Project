import decimal
import unittest
import psycopg2

SQL_DIR_PREFIX = '../scripts/windows_and_views/'

class TestQueries(unittest.TestCase):

    def setUp(self):
        # Connect to the database
        self.conn = psycopg2.connect(database="project", user="postgres", password="postgres", host="localhost")

        # Create a cursor
        self.cur = self.conn.cursor()

    def test_window_and_views(self):
        '''Проверка оконных функций и представлений'''

        with self.conn, self.conn.cursor() as cursor:
            with open(f"{SQL_DIR_PREFIX}win_probability.sql") as f:
                query = f.read()

            cursor.execute(query)
            result = cursor.fetchall()

        expected = [
            ("A00", "Polish (Sokolsky) opening", 575, 483, 270, 1328, decimal.Decimal("43.30"), decimal.Decimal("36.37"), decimal.Decimal("20.33")),
            ("A01", "Nimzovich-Larsen attack", 1183, 879, 493, 2555, decimal.Decimal("46.30"), decimal.Decimal("34.40"), decimal.Decimal("19.30")),
            ("A02", "Bird's Opening", 468, 440, 148, 1056, decimal.Decimal("44.32"), decimal.Decimal("41.67"), decimal.Decimal("14.02")),
        ]

        # Check number of rows
        self.assertEqual(len(result), 500)

        # Check number of columns
        self.assertEqual(len(result[0]), 9)

        for i in range(3):
            self.assertEqual(result[i][0], expected[i][0])
            self.assertEqual(result[i][1], expected[i][1])
            self.assertEqual(result[i][2], expected[i][2])
            self.assertEqual(result[i][3], expected[i][3])
            self.assertEqual(result[i][4], expected[i][4])
            self.assertAlmostEqual(result[i][5], expected[i][5], delta=0.01)
            self.assertAlmostEqual(result[i][6], expected[i][6], delta=0.01)
            self.assertAlmostEqual(result[i][7], expected[i][7], delta=0.01)
            self.assertAlmostEqual(result[i][8], expected[i][8], delta=0.01)

    def test_most_common_opening(self):
        '''Проверка наиболее популярных открытий'''

        with self.conn, self.conn.cursor() as cursor:
            with open(f"{SQL_DIR_PREFIX}/most_common_opening.sql") as f:
                query = f.read()

            cursor.execute(query)
            result = cursor.fetchmany(3)

            row_count = cursor.rowcount

        expected = [
            ("Le", "Minh", "B29", "Sicilian", 93, 58),
            ("Ruben", "Koellner", "A45", "Queen's pawn game", 108, 52),
            ("Olexandr", "Bortnyk", "B22", "Sicilian", 60, 45),
        ]

        # Check number of rows
        self.assertEqual(row_count, 126712)

        # Check number of columns
        self.assertEqual(len(result[0]), 6)

        self.assertEqual(result[:3], expected)

    def test_window_top_15(self):
        '''Test the top 15 players query'''

        with self.conn, self.conn.cursor() as cursor:
            with open(f"{SQL_DIR_PREFIX}/window_top_15.sql") as f:
                query = f.read()

            cursor.execute(query)
            result = cursor.fetchall()

        expected = [
            (1, 1503014, 'Magnus', 'Carlsen', 'NOR', 'M', 1990, 'GM', 2839),
            (2, 8603677, 'Liren', 'Ding', 'CHN', 'M', 1992, 'GM', 2829),
            (3, 5202213, 'Wesley', 'So', 'USA', 'M', 1993, 'GM', 2788),
            # Add more expected rows here
        ]

        # Check number of rows
        self.assertEqual(len(result), 15)

        # Check number of columns
        self.assertEqual(len(result[0]), 9)

        self.assertEqual(result[:3], expected)

    def tearDown(self):
        # Close the cursor and connection
        self.cur.close()
        self.conn.close()


if __name__ == '__main__':
    unittest.main()
