@IsTest
private class DateTimeFormatterInvocable_TEST {

    @IsTest
    static void testMidnightAndNoon() {
        // 2024-03-10 17:00 UTC = 17:00 GMT (Ireland in winter, before clocks change)
        Datetime dt = Datetime.newInstanceGmt(2024, 3, 10, 17, 0, 0);

        DateTimeFormatterInvocable.Request req = new DateTimeFormatterInvocable.Request();
        req.inputDateTime = dt;

        List<DateTimeFormatterInvocable.Result> results =
            DateTimeFormatterInvocable.formatDateTime(new List<DateTimeFormatterInvocable.Request>{ req });

        System.assertEquals(1, results.size());
        System.assertNotEquals(null, results[0].formattedDate, 'formattedDate should not be null');
        System.assertNotEquals(null, results[0].formattedTime, 'formattedTime should not be null');
        System.assert(results[0].formattedDate.contains('/'), 'Date should be in DD/MM/YYYY format');
        System.assert(results[0].formattedTime.contains(':'), 'Time should be in HH:mm format');
    }

    @IsTest
    static void testMinutePadding() {
        // Minute should be zero-padded to "05"
        // 18:05 UTC = 19:05 IST (Ireland in summer)
        Datetime dt = Datetime.newInstanceGmt(2024, 6, 15, 18, 5, 0);

        DateTimeFormatterInvocable.Request req = new DateTimeFormatterInvocable.Request();
        req.inputDateTime = dt;

        List<DateTimeFormatterInvocable.Result> results =
            DateTimeFormatterInvocable.formatDateTime(new List<DateTimeFormatterInvocable.Request>{ req });

        System.assert(results[0].formattedTime.contains(':0'), 'Single-digit minutes should be zero-padded');
    }

    @IsTest
    static void testNullInput() {
        DateTimeFormatterInvocable.Request req = new DateTimeFormatterInvocable.Request();
        req.inputDateTime = null;

        List<DateTimeFormatterInvocable.Result> results =
            DateTimeFormatterInvocable.formatDateTime(new List<DateTimeFormatterInvocable.Request>{ req });

        System.assertEquals(1, results.size());
        System.assertEquals(null, results[0].formattedDate);
        System.assertEquals(null, results[0].formattedTime);
    }

    @IsTest
    static void testBulkRequests() {
        List<DateTimeFormatterInvocable.Request> reqs = new List<DateTimeFormatterInvocable.Request>();
        for (Integer i = 0; i < 200; i++) {
            DateTimeFormatterInvocable.Request req = new DateTimeFormatterInvocable.Request();
            req.inputDateTime = Datetime.newInstanceGmt(2024, 1, 1, 12, 0, 0);
            reqs.add(req);
        }

        List<DateTimeFormatterInvocable.Result> results = DateTimeFormatterInvocable.formatDateTime(reqs);
        System.assertEquals(200, results.size());
    }
}
