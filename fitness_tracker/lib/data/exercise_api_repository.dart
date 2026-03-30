import 'package:dio/dio.dart';
import 'models/api_exercise.dart';


class ExerciseApiRepository {
  static const String _baseUrl = 'https://api.api-ninjas.com/v1/exercises';


  static const String _apiKey = 'vbJyS6e5Ap0P6nkJQPV7BRmRg1I65pa9TK6MLBXT';

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );


  Future<List<ApiExercise>> searchExercises({
    String? muscle,
    String? type,
    String? difficulty,
    String? name,
  }) async {

    final params = <String, String>{};
    if (muscle    != null && muscle.isNotEmpty)     params['muscle']     = muscle;
    if (type      != null && type.isNotEmpty)       params['type']       = type;
    if (difficulty != null && difficulty.isNotEmpty) params['difficulty'] = difficulty;
    if (name      != null && name.isNotEmpty)       params['name']       = name;

    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: params,
        options: Options(
          headers: {'X-Api-Key': _apiKey},
        ),
      );


      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((item) => ApiExercise.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception('Connection timed out. Check your internet.');

        case DioExceptionType.badResponse:
          final statusCode = e.response?.statusCode;
          if (statusCode == 401) {
            throw Exception('Invalid API key. Check your API Ninjas key.');
          } else if (statusCode == 429) {
            throw Exception('Rate limit exceeded. Wait a moment and try again.');
          } else {
            throw Exception('Server error: $statusCode');
          }

        case DioExceptionType.connectionError:
          throw Exception('No internet connection.');

        default:
          throw Exception('No internet connection.');
      }
    } catch (e) {

      throw Exception('Failed to load exercises: $e');
    }
  }
}