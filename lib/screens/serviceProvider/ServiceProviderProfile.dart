import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:workup/widgets/sp_bottom_navigation_bar.dart';

class ServiceProviderProfile extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ServiceProviderProfile({Key? key, required this.userData})
      : super(key: key);

  handleBackClick() {}

  handleChatClick() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Center(
            child: Text(
          "Bid Details Page",
          style: AppTextStyles.title.merge(AppTextStyles.textWhite),
        )),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.white,
          ),
          onPressed: handleBackClick,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.chat_rounded,
              color: AppColors.white,
            ),
            onPressed: handleChatClick,
          )
        ],
      ),
      bottomNavigationBar: const SPCustomBottomNavigationBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildInfoSection(),
            const SizedBox(height: 24),
            _buildDetailsSection(),
            const SizedBox(height: 24),
            _buildSpecialtiesSection(),
            const SizedBox(height: 24),
            _buildVerificationStatus(),
            const SizedBox(height: 24),
            _buildReviewsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.grey,
          backgroundImage: userData['imgURL'] != null
              ? NetworkImage(userData['imgURL'] as String)
              : null,
          child: userData['imgURL'] == null
              ? const Icon(Icons.person, size: 50, color: AppColors.darkGrey)
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${userData['firstName']} ${userData['middleName'] ?? ''} ${userData['lastName']}'
                    .trim(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.star, color: AppColors.secondary, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${userData['rating']} (${userData['reviewCount']} reviews)',
                    style: const TextStyle(
                      color: AppColors.mediumGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: userData['newSProvider']
                      ? AppColors.tertiary
                      : AppColors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  userData['newSProvider'] ? 'New Provider' : 'Experienced',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey),
          ),
          child: Text(
            userData['info'] ?? 'No information provided',
            style: const TextStyle(color: AppColors.darkGrey),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    final joiningDate = userData['joiningDate'] != null
        ? DateFormat('MMM dd, yyyy')
            .format(DateTime.parse(userData['joiningDate']))
        : 'Not available';

    final dateOfBirth = userData['dateOfBirth'] != null
        ? DateFormat('MMM dd, yyyy')
            .format(DateTime.parse(userData['dateOfBirth']))
        : 'Not provided';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey),
          ),
          child: Column(
            children: [
              _buildDetailRow(Icons.email, 'Email', userData['email'], true),
              _buildDetailRow(
                  Icons.phone, 'Phone', userData['phoneNumber'], true),
              _buildDetailRow(
                  Icons.calendar_today, 'Member since', joiningDate, false),
              _buildDetailRow(Icons.cake, 'Date of Birth', dateOfBirth, false),
              _buildDetailRow(
                Icons.money,
                'Starting price',
                userData['startingPrice'] > 0
                    ? '${userData['startingPrice']}'
                    : 'Not specified',
                false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
      IconData icon, String label, String value, bool isClickable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: isClickable
            ? () {
                // Add action for clickable items (email/phone)
                if (label == 'Email') {
                  // launchEmail(value);
                } else if (label == 'Phone') {
                  // launchPhone(value);
                }
              }
            : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.mediumGrey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      color:
                          isClickable ? AppColors.primary : AppColors.darkGrey,
                      fontSize: 14,
                      decoration: isClickable
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialtiesSection() {
    final subcategories = userData['subcategories'] as List<dynamic>? ?? [];
    final languages = userData['languages'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Specialties',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subcategories.isNotEmpty) ...[
                const Text(
                  'Services:',
                  style: TextStyle(
                    color: AppColors.mediumGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: subcategories
                      .map((cat) => Chip(
                            label: Text(
                              cat.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: AppColors.lightPrimary,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
              ],
              if (languages.isNotEmpty) ...[
                const Text(
                  'Languages:',
                  style: TextStyle(
                    color: AppColors.mediumGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: languages
                      .map((lang) => Chip(
                            label: Text(
                              lang.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: AppColors.lightSecondary,
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationStatus() {
    final status = userData['verificationStatus'] ?? 'pending';
    final activityStatus = userData['activityStatus'] ?? 'inactive';

    Color statusColor;
    switch (status) {
      case 'verified':
        statusColor = Colors.green;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = AppColors.mediumGrey;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.verified,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Verification',
                          style: TextStyle(
                            color: AppColors.mediumGrey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    activityStatus == 'active'
                        ? Icons.check_circle
                        : Icons.circle,
                    color:
                        activityStatus == 'active' ? Colors.green : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Activity',
                          style: TextStyle(
                            color: AppColors.mediumGrey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          activityStatus == 'active'
                              ? 'Currently Active'
                              : 'Inactive',
                          style: TextStyle(
                            color: activityStatus == 'active'
                                ? Colors.green
                                : Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    final reviews = userData['reviews'] as List<dynamic>? ?? [];

    if (reviews.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Reviews',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: reviews.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.secondary, size: 16),
                      const SizedBox(width: 4),
                      Text(review['rating'].toString()),
                      const Spacer(),
                      Text(
                        DateFormat('MMM dd, yyyy')
                            .format(DateTime.parse(review['date'])),
                        style: const TextStyle(
                          color: AppColors.mediumGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review['comment'],
                    style: const TextStyle(
                      color: AppColors.darkGrey,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
