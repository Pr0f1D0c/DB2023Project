import decimal
import unittest
import psycopg2

SQL_DIR_PREFIX = '../scripts/SELECTs/countries'

class TestQueries(unittest.TestCase):

    def setUp(self):
        # Connect to the database
        self.conn = psycopg2.connect(database="project", user="postgres", password="postgres", host="localhost")

        # Create a cursor
        self.cur = self.conn.cursor()

    def test_countries_counties_KAZ(self):
        '''Проверка сильнейшего игрока Казахстана'''
        with self.conn, self.conn.cursor() as cursor:
            with open(SQL_DIR_PREFIX + "/counties_KAZ.sql") as f:
                query = f.read()

            cursor.execute(query)
            result = cursor.fetchall()

        expected = [
            (13700464, "Darmen", "Sadvakasov", "KAZ", "M", 1979, "GM", 2601)
        ]

        self.assertEqual(result, expected)

    def test_counties_players_cnt(self):
        '''Проверка количества игроков по странам'''
        with self.conn, self.conn.cursor() as cursor:
            with open(SQL_DIR_PREFIX +  '/counties_players_cnt.sql') as f:
                query = f.read()

            cursor.execute(query)
            result = cursor.fetchall()

        expected = [
            ("RUS", 37545, 1558, 2783),
            ("FRA", 17376, 1459, 2762),
            ("IND", 16498, 1323, 2731)
        ]

        self.assertEqual(len(result), 191)
        self.assertEqual(result[:3], expected)

    def test_countries_full_stats(self):
        '''Проверка статистики стран'''
        with self.conn, self.conn.cursor() as cursor:
            with open(f"{SQL_DIR_PREFIX}/countries_full_stats.sql") as f:
                query = f.read()

            cursor.execute(query)
            result = cursor.fetchall()

        expected = [
            ('KOS', 843, decimal.Decimal(1017.029655990510083), 2387, 0),
            ('BIH', 3470, decimal.Decimal(902.5590778097982709), 2634, 0),
            ('MKD', 1481, decimal.Decimal(767.4659014179608373), 2618, 0)
        ]

        self.assertEqual(len(result), 204)

        for i in range(3):
            self.assertEqual(result[i][0], expected[i][0])
            self.assertEqual(result[i][1], expected[i][1])
            self.assertAlmostEqual(result[i][2], expected[i][2], delta=0.0001)
            self.assertEqual(result[i][3], expected[i][3])
            self.assertEqual(result[i][4], expected[i][4])

    def test_country_avg_elo(self):
        '''Проверка среднего ELO игроков каждой страны'''
        with self.conn, self.conn.cursor() as cursor:
            with open(f"{SQL_DIR_PREFIX}/country_avg_elo.sql") as f:
                query = f.read()

            cursor.execute(query)
            result = cursor.fetchall()

        expected = [
            ("KOS", 843, decimal.Decimal(1017.029655990510083), 2387, 0),
            ("BIH", 3470, decimal.Decimal(902.5590778097982709), 2634, 0),
            ("MKD", 1481, decimal.Decimal(767.4659014179608373), 2618, 0)
        ]

        # Check number of rows
        self.assertEqual(len(result), 131)

        # Check number of columns
        self.assertEqual(len(result[0]), 5)

        for i in range(3):
            self.assertEqual(result[i][0], expected[i][0])
            self.assertEqual(result[i][1], expected[i][1])
            self.assertAlmostEqual(result[i][2], expected[i][2], delta=0.0001)
            self.assertEqual(result[i][3], expected[i][3])
            self.assertEqual(result[i][4], expected[i][4])

    def test_some_smart_selects(self):
        '''Проверка некоторых умных SELECT запросов'''
        with self.conn, self.conn.cursor() as cursor:
            with open( "../scripts/SELECTs/some_smart_selects.sql") as f:
                query = f.read()

            cursor.execute(query)
            result = cursor.fetchall()

        expected = [
            (14103400, "Andreev Eduard", 2415, 2376, "GM", "GM"),
            (24239305, "Andreev Konstantin", 2087, 2079, "CM", "CM"),
            (4134982, "Andreeva Olga", 2125, 2021, "WFM", "WF"),
            (2212595, "Andres Gonzalez Alberto", 2489, 2469, "GM", "IM"),
            (2000377, "Fishbein Alexander", 2387, 0, "GM", "GM"),
            (4100026, "Karpov Anatoly", 2618, 2583, "GM", "GM"),
            (4606965, "Kiefer Gerhard", 2260, 0, "FM", "FM"),
            (14000091, "Odeev Handszar", 2278, 0, "GM", "GM"),
            (4677501, "Rueberg Jobst", 2070, 0, "FM", "FM"),
            (14201399, "Turaev Halim", 2113, 2071, "FM", "FM")
        ]

        # Check number of rows
        self.assertEqual(len(result), 10)

        # Check number of columns
        self.assertEqual(len(result[0]), 6)

        for i in range(10):
            self.assertEqual(result[i][0], expected[i][0])
            self.assertEqual(result[i][1], expected[i][1])
            self.assertAlmostEqual(result[i][2], expected[i][2], delta=0.0001)
            self.assertAlmostEqual(result[i][3], expected[i][3], delta=0.0001)
            self.assertEqual(result[i][4], expected[i][4])
            self.assertEqual(result[i][5], expected[i][5])

    def test_windows_and_views(self):
        '''Проверка создания оконных функций и представлений'''
        with self.conn, self.conn.cursor() as cursor:
            with open("../scripts/windows_and_views.sql") as f:
                query = f.read()

            cursor.execute(query)
            result = cursor.fetchall()

        expected = [
            ("A00", "Polish (Sokolsky) opening", 575, 483, 270, 1328, decimal.Decimal("43.3")),
            ("A01", "Nimzovich-Larsen attack", 1183, 879, 493, 2555, decimal.Decimal("46.3")),
            ("A02", "Bird's Opening", 468, 440, 148, 1056, decimal.Decimal("44.32")),
            # Add more expected rows here
        ]

        # Check number of rows
        self.assertEqual(len(result), 500)

        # Check number of columns
        self.assertEqual(len(result[0]), 7)

        for i in range(3):
            self.assertEqual(result[i][0], expected[i][0])
            self.assertEqual(result[i][1], expected[i][1])
            self.assertEqual(result[i][2], expected[i][2])
            self.assertEqual(result[i][3], expected[i][3])
            self.assertEqual(result[i][4], expected[i][4])
            self.assertEqual(result[i][5], expected[i][5])
            self.assertAlmostEqual(result[i][6], expected[i][6], delta=0.01)

    def tearDown(self):
        # Close the cursor and connection
        self.cur.close()
        self.conn.close()


if __name__ == '__main__':
    unittest.main()
