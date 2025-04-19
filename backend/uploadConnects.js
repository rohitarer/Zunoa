const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json'); // 🔐 your Firebase service account key

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const connects = [
    {
      "name": "Dr. Aarti Mehta",
      "profileImage": "https://images.unsplash.com/photo-1607746882042-944635dfe10e",
      "degrees": "MBBS, MD (Psychiatry)",
      "price": 500,
      "availability": {
        "monday": "10am - 4pm",
        "tuesday": "11am - 5pm",
        "wednesday": "Unavailable",
        "thursday": "1pm - 6pm",
        "friday": "10am - 3pm",
        "saturday": "10am - 2pm",
        "sunday": "Unavailable"
      },
      "description": "Specialist in adolescent mental health and stress management.",
      "experience": "10+ years in clinical practice"
    },
    {
      "name": "Dr. Rohan Shah",
      "profileImage": "https://images.unsplash.com/photo-1527613426441-4da17471b66d",
      "degrees": "MBBS, DPM (Psychiatry)",
      "price": 800,
      "availability": {
        "monday": "9am - 1pm",
        "tuesday": "1pm - 5pm",
        "wednesday": "10am - 3pm",
        "thursday": "Unavailable",
        "friday": "9am - 1pm",
        "saturday": "10am - 12pm",
        "sunday": "Unavailable"
      },
      "description": "Expert in adult psychiatry and behavioral therapy.",
      "experience": "8+ years in clinical practice"
    },
    {
      "name": "Dr. Sneha Kulkarni",
      "profileImage": "https://images.unsplash.com/photo-1607746882193-7c4bfe063b38",
      "degrees": "MBBS, MRC Psych (UK)",
      "price": 1200,
      "availability": {
        "monday": "10am - 6pm",
        "tuesday": "10am - 6pm",
        "wednesday": "Unavailable",
        "thursday": "10am - 6pm",
        "friday": "10am - 2pm",
        "saturday": "10am - 12pm",
        "sunday": "Unavailable"
      },
      "description": "Mental health specialist with global exposure.",
      "experience": "12+ years with international experience"
    },
    {
      "name": "Dr. Karan Malhotra",
      "profileImage": "https://images.unsplash.com/photo-1612226665204-3d245d81fc76",
      "degrees": "MBBS, MD, DM (Neurology)",
      "price": 1000,
      "availability": {
        "monday": "2pm - 8pm",
        "tuesday": "2pm - 8pm",
        "wednesday": "2pm - 5pm",
        "thursday": "2pm - 8pm",
        "friday": "2pm - 5pm",
        "saturday": "10am - 1pm",
        "sunday": "Unavailable"
      },
      "description": "Neuropsychiatrist with expertise in degenerative disorders.",
      "experience": "15+ years in neurology and psychiatry"
    },
    {
      "name": "Dr. Neha Sharma",
      "profileImage": "https://images.unsplash.com/photo-1588776814546-bfd6f0edbfcd",
      "degrees": "MBBS, DNB (Psychiatry)",
      "price": 700,
      "availability": {
        "monday": "10am - 4pm",
        "tuesday": "Unavailable",
        "wednesday": "10am - 4pm",
        "thursday": "10am - 4pm",
        "friday": "10am - 4pm",
        "saturday": "10am - 1pm",
        "sunday": "Unavailable"
      },
      "description": "Women’s mental wellness specialist and counselor.",
      "experience": "9+ years focused on women's health"
    },
    {
      "name": "Dr. Anil Deshmukh",
      "profileImage": "https://images.unsplash.com/photo-1550831107-1553da8c8464",
      "degrees": "MBBS, MD (Psychiatry)",
      "price": 600,
      "availability": {
        "monday": "9am - 3pm",
        "tuesday": "10am - 2pm",
        "wednesday": "10am - 3pm",
        "thursday": "1pm - 5pm",
        "friday": "Unavailable",
        "saturday": "10am - 1pm",
        "sunday": "Unavailable"
      },
      "description": "Focused on rehabilitation and substance abuse therapy.",
      "experience": "11+ years in government and private hospitals"
    },
    {
      "name": "Dr. Vandana Jain",
      "profileImage": "https://images.unsplash.com/photo-1587502537104-8018a4b06d4a",
      "degrees": "MBBS, DNB, MSc (Psychology)",
      "price": 950,
      "availability": {
        "monday": "2pm - 8pm",
        "tuesday": "Unavailable",
        "wednesday": "2pm - 8pm",
        "thursday": "2pm - 6pm",
        "friday": "2pm - 5pm",
        "saturday": "12pm - 3pm",
        "sunday": "Unavailable"
      },
      "description": "Trauma-informed therapist and behavioral consultant.",
      "experience": "13+ years in urban clinical practices"
    },
    {
      "name": "Dr. Manav Gupta",
      "profileImage": "https://images.unsplash.com/photo-1622253692010-4c0ef446c36c",
      "degrees": "MBBS, MD, PhD (Neuroscience)",
      "price": 1500,
      "availability": {
        "monday": "10am - 6pm",
        "tuesday": "10am - 6pm",
        "wednesday": "10am - 6pm",
        "thursday": "10am - 6pm",
        "friday": "10am - 6pm",
        "saturday": "11am - 2pm",
        "sunday": "Unavailable"
      },
      "description": "Consultant psychiatrist and neuroscience researcher.",
      "experience": "16+ years in clinical and academic roles"
    }
  ];  

async function uploadData() {
  const batch = db.batch();

  connects.forEach((doc) => {
    const ref = db.collection('connects').doc();
    batch.set(ref, doc);
  });

  await batch.commit();
  console.log("✅ All doctor profiles added successfully!");
}

uploadData();
