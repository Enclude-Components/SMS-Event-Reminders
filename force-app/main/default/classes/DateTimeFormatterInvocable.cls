/**
 * @description     Invocable action for formatting a DateTime value into separate date (DD/MM/YYYY) and time (HH:mm)
 *                  strings in Irish time (Europe/Dublin), with correct DST handling.
 * @since           12/05/2026
 * @author          Brandon DeMatteis, Enclude
 */
public inherited sharing class DateTimeFormatterInvocable {

    public class Request {
        @InvocableVariable(required=true label='DateTime Value')
        public Datetime inputDateTime;
    }

    public class Result {
        @InvocableVariable(label='Formatted Date (DD/MM/YYYY)')
        public String formattedDate;

        @InvocableVariable(label='Formatted Time (HH:mm)')
        public String formattedTime;
    }

    /**
     * @description     Converts a list of DateTime values to localised date and time strings, accounting for DST
     * @param           requests List of Request objects each containing a DateTime to format
     * @return          List of Result objects containing formattedDate (DD/MM/YYYY) and formattedTime (HH:mm)
     */
    @InvocableMethod(label='Format Date Time' description='Converts a DateTime to DD/MM/YYYY date and HH:mm time strings in Irish time (Europe/Dublin), including DST.')
    public static List<Result> formatDateTime(List<Request> requests) {
        List<Result> results = new List<Result>();

        for (Request req : requests) {
            Result res = new Result();
            if (req.inputDateTime != null) {
                res.formattedDate = req.inputDateTime.format('dd/MM/yyyy', 'Europe/Dublin');
                res.formattedTime = req.inputDateTime.format('HH:mm', 'Europe/Dublin');
            }
            results.add(res);
        }

        return results;
    }
}
