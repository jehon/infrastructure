
import unittest

import jehon.office as jo

TEST_DATA = __file__.replace('.py', '/')

class TestJehonOffice (unittest.TestCase):
    def test_load_csv(self):
        workbook = jo.spreadsheet_open(TEST_DATA + 'csv.csv', delimiter=';')

        self.assertEqual('JIRA-1', workbook['csv']['B2'].value)
        self.assertEqual('implémentation', workbook['csv']['C3'].value)

    def test_headers(self):
        workbook = jo.spreadsheet_open(TEST_DATA + 'xlsx.xlsx')

        headers = jo.worksheet_headers(workbook['data'])

        self.assertEqual(1, headers['clé'])
        self.assertEqual(2, headers['nom'])
        self.assertEqual(3, headers['titre'])

    def test_inject(self):
        workbook = jo.spreadsheet_open(TEST_DATA + 'xlsx.xlsx')
        result = jo.worksheet_inject(workbook['data'], workbook['inject'])

        self.assertEqual('titre de clé 1', result['A2'].value)
        self.assertEqual('nom de clé 1', result['B2'].value)
        self.assertEqual(None, result['C2'].value)

        self.assertEqual('titre de clé 2', result['A3'].value)
        self.assertEqual('nom de clé 2', result['B3'].value)
        self.assertEqual(None, result['C3'].value)

        self.assertEqual('titre de clé 3', result['A4'].value)
        self.assertEqual('nom de clé 3', result['B4'].value)
        self.assertEqual(None, result['C4'].value)

        self.assertEqual('', result['A5'].value)

if __name__ == '__main__':
    unittest.main()
